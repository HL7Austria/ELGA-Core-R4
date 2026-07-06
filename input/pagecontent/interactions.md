{% include styleheader.md %}

<!-- Transaktionen -->

### Listen

Im Folgenden werden standardisierte Interaktionen für den lesenden und schreibenden Zugriff auf persistierte Listen beschrieben. Die Interaktionen definieren einen einheitlichen Mechanismus für das Lesen, Bearbeiten und Schreiben von Listen auf Basis der FHIR-Ressource List und sind unabhängig vom fachlichen Inhalt der Liste.

Die beschriebenen Abläufe können für unterschiedliche Anwendungsfälle verwendet werden.

#### Grundkonzept

Für jeden fachlichen Listentyp existiert pro Patient bzw. Patientin höchstens eine aktuelle Liste. Die Zuordnung erfolgt über das Element List.code, welches den fachlichen Typ einer Liste eindeutig kennzeichnet (z.B. Medikationsplan, Diagnosenliste oder Problemliste).

Alle in diesem Kapitel beschriebenen Interaktionen beziehen sich auf diejenige Liste, deren *List.code* dem angeforderten Listentyp entspricht.

Existiert für einen Patienten bzw. eine Patientin noch keine Liste mit dem angeforderten List.code, wird diese – sofern durch die jeweilige Interaktion vorgesehen – neu angelegt. Listen mit unterschiedlichen List.code-Werten werden unabhängig voneinander verwaltet und versioniert.

#### List-History-Read 

Beim List-History-Read stellt die Fachanwendung **die aktuelle oder historische Version(en)** der Liste inkl. aller referenzierten Ressourcen ([persistiertes Listen-Collection-Bundle](design_choices.html#persistiertes-Listen-collection-bundle)) **unverändert** bereit.


##### Ablauf

1. Der Client führt ein **GET** auf das *persistierte Listen-Collection-Bundle* aus.
2. Die Fachanwendung prüft, ob für den Patienten bzw. die Patientin eine Liste mit dem angeforderten List.code existiert.
3. Ist **keine** Liste mit diesem *List.code* vorhanden, wird ein **leeres Ergebnis** zurückgegeben.
4. Ist eine Liste mit diesem *List.code* vorhanden, wird das **zuletzt persistierte Listen-Collection-Bundle** zurückgeliefert.
Das Collection Bundle enthält:
* die List-Ressource
* alle referenzierten Ressourcen vollständig (inline).

Beim List-History-Read erfolgt **keine Veränderung** von Flags, Status oder Inhalten. Der Zugriff dient ausschließlich der Anzeige aktueller oder historischer Listenversionen.


##### Sequenzdiagramm List-History-Read
<br>
<div>{% include_relative plantuml/interaction_listhistoryread.svg %}</div>
<br>

**Beispiele für Zugriffe mittels Suchparameter:** In Arbeit.
<!-- * **Aktuelle Planversion** mit dem Suchparameter Patient abrufen: GET [base]/Bundle?type=collection&_count=1&_sort=-timestamp&List.subject={bPK-GH}
* **Alle Planversionen** mit dem Suchparameter Patient abrufen: GET [base]/Bundle?type=collection&_sort=-timestamp&List.subject={bPK-GH}
* Abfrage aller **historischen Medikationsplan-Versionen** eines Patienten, die nach dem angegebenen Datum gespeichert wurden und Plan-Einträge enthalten, die als **storniert, beendet oder abgesetzt** gekennzeichnet sind: GET [base]/Bundle?type=collection&_sort=-timestamp&timestamp=ge2025-01-01&List.subject={bPK-GH}&List.entry.flag=removed -->

<!-- List.code= 736378000 in Abfragen ergänzen -->

#### List-Read

List-Read dient dem Abruf einer Liste und der **Vorbereitung einer nachfolgenden Änderung.**

##### Ablauf

1. Der GDA führt ein POST [$list-read](OperationDefinition-AtEmed.List.Listread.html) auf das Collection Bundle aus, das die Liste mit allen zugehörigen relevanten Ressourcen enthält.
2. Die Fachanwendung prüft, ob für den Patienten bzw. die Patientin bereits eine Liste mit dem angeforderten List.code existiert.
3. Ist keine Liste mit diesem List.code vorhanden, wird eine neue **Liste angelegt**.
4. Anschließend wird eine leere Liste mit dem **entsprechenden List.code** und *List.emptyReason* = **notstarted** zurückgeliefert. 
5. Existiert bereits eine Liste mit diesem List.code, erstellt die Fachanwendung daraus ein Auslieferungs-Collection-Bundle  [Auslieferungs-Collection-Bundle](design_choices.html#auslieferungs-collection-bundle) bereitgestellt. Die Inhalte werden von der Fachanwendung wie folgt aufbereitet:<br>
* Falls der vorherige GDA neue Listeneinträge hinzugefügt oder bestehende geändert hat (*List.entry.flags* haben den Wert **new** oder **changed**), werden diese auf **unchanged** gesetzt.<br>
* Falls der vorherige GDA Listeneinträge beendet hat (deren *List.entry.flags* haben den Wert **removed**), werden diese Einträge aus der Liste **entfernt**.<br>
* Falls der vorherige GDA **alle vorhandenen Listeneinträge** mit **removed** gekennzeichnet hat, wird *List.emptyReason* auf **nilknown** gesetzt. Dadurch wird nachfolgenden GDA signalisiert, dass die Liste bewusst leer ist und dieser Zustand fachlich beabsichtigt ist (z.B. keine aktuelle Medikation, keine bekannten Diagnosen oder keine vorhandenen Einträge des jeweiligen Listentyps).
6. Die Fachanwendung liefert das [Auslieferungs-Collection-Bundle](design_choices.html#auslieferungs-collection-bundle) an den GDA:<br>
* inkl. *ETag* für [Optimistic Locking](https://hl7.org/fhir/http.html#concurrency)
* inkl. List und aller referenzierten Ressourcen (inline)<br>
* Ziel ist ein neutraler, weiterbearbeitbarer Zustand für den abrufenden GDA<br>
7. Der GDA bearbeitet die Liste (er fügt Einträge hinzu, ändert bestehende oder entfernt diese).


##### Custom Operations

[$plan-read](OperationDefinition-AtEmed.List.Listread.html)


##### Sequenzdiagramm List-Read
<br>
<div>{% include_relative plantuml/interaction_listread.svg %}</div>
<br>


#### List-Write

List-Write ist eine eigenständige Operation, die ausschließlich im Kontext eines **zuvor ausgeführten** [List-Read](interactions.html#list-read) erfolgen darf.

##### Ablauf

1. Der GDA übermittelt via POST [$list-write](OperationDefinition-AtEmed.List.Write.html) die aktualisierte Liste als [List-Transaction-Bundle](design_choices.html#list-transaction-bundle) inkl. *ETag* für [Optimistic Locking](https://hl7.org/fhir/http.html#concurrency):
* alle **neuen und geänderten und zu entfernenden Ressourcen** sind **inline** im Bundle enthalten,
* alle unveränderten Ressourcen werden nur referenziert.
2. Die Fachanwendung prüft, ob der im Header übermittelte ***ETag*** mit dem *ETag* der Fachanwendung **übereinstimmt** (d.h. es wurde zwischenzeitlich keine Liste mit diesem *List.code* gespeichert).
3. Stimmt der *ETag* nicht überein, lehnt die Fachanwendung das Speichern der Liste ab.
Es muss erneut ein [List-Read](interactions.html#plan-read) ausgeführt werden und die Aktualisierungen übernommen werden bzw. Fehler behoben werden, bevor ein neuerlicher Speicherversuch vorgenommen werden kann.
4. Wenn kein Fehler auftritt, validiert die Fachanwendung die neue Liste und stellt sicher, dass keine unzulässigen Zustandsübergänge vorgenommen wurden.
5. Bei erfolgreicher Prüfung werden die übermittelten Änderungen übernommen und auf Basis der aktualisierten Ressourcen ein neues [Listen-Collection-Bundle](design_choices.html#persistiertes-list-collection-bundle) mit demselben List.code erstellt und als neue Version dieser Liste persistiert.
6. Der GDA erhält eine Meldung, dass die Liste erfolgreich aktualisiert wurde.


##### Custom Operations

[$list-write](OperationDefinition-AtEmed.List.Write.html)


##### Sequenzdiagramm List-Write
<br>
<div>{% include_relative plantuml/interaction_listwrite.svg %}</div>
<br>


<!-- ##### Diagramm Plan-Read- und Write-Logik -->
<!-- [![diagram](class_diagram_planread_planwrite.drawio.svg){: style="width: 80%"}](class_diagram_planread_planwrite.drawio.svg) -->


##### Abgelehntes Plan-Write

##### Ablauf


1. **GDA 1** möchte eine Liste bearbeiten und führt ein POST auf [$list-read](OperationDefinition-AtEmed.List.Planread.html) aus.
2. Die Fachanwendung erstellt ein **Auslieferungs-Collection-Bundle** (siehe List-Read) einschließlich *ETag* "123" und liefert dieses an GDA 1 zurück. GDA 1 beginnt mit der Bearbeitung der Liste.
3. Währenddessen führt **GDA 2** ebenfalls ein POST auf $list-read für dieselbe Liste (identifiziert durch List.code) aus.
4. Die Fachanwendung erstellt ein weiteres Auslieferungs-Collection-Bundle einschließlich *ETag* "123" und liefert dieses an GDA 2 zurück. Beide GDA bearbeiten nun dieselbe Version der Liste parallel.
5. GDA 2 schließt seine Änderungen zuerst ab und übermittelt mittels POST $list-write ein Listen-Transaction-Bundle einschließlich des *ETag* "123".
6. Die Fachanwendung prüft den übermittelten *ETag*. Da dieser mit dem aktuellen *ETag* der Fachanwendung **übereinstimmt**, werden die Änderungen übernommen und eine **neue Version der Liste persistiert**.
7. GDA 2 erhält eine Bestätigung, dass die Liste erfolgreich aktualisiert wurde.
8. Anschließend übermittelt GDA 1 seine Änderungen ebenfalls mittels POST $list-write und verwendet dabei weiterhin den *ETag* "123".
9. Die Fachanwendung stellt fest, dass der übermittelte *ETag* nicht mehr dem aktuellen Stand entspricht, da zwischenzeitlich bereits eine neue Version der Liste gespeichert wurde. Das Speichern wird daher **abgelehnt**.
10. GDA 1 erhält eine Fehlermeldung. Vor einem erneuten Schreibversuch muss der GDA ein neues List-Read durchführen, um die aktuelle Version der Liste einschließlich des aktuellen *ETag* abzurufen und seine Änderungen auf dieser Version erneut anzuwenden.


##### Sequenzdiagramm Abgelehntes List-Write
<br>
<div>{% include_relative plantuml/interaction_listwrite_error.svg %}</div>
<br>

