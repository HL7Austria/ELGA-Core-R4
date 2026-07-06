{% include styleheader.md %}

### Relevante Profile

#### ELGA Liste: AtElgaCoreList (*List*)

Die Ressource AtElgaCoreList repräsentiert eine generische ELGA-Liste für einen bestimmten fachlichen Anwendungsfall. Der Typ der Liste wird durch das Element *List.code* bestimmt. Pro Patient bzw. Patientin kann je *List.code* genau eine aktuelle Liste existieren.

Eine Liste enthält 0..* Listeneinträge (*List.entry*). Jeder Listeneintrag referenziert über *List.entry.item* genau eine fachspezifische Ressource. Die Reihenfolge der Listeneinträge ist fachlich relevant und wird durch die Reihenfolge der *List.entry*-Elemente festgelegt.

Der Änderungsstatus eines Listeneintrags wird im Element *List.entry.flag* angegeben (siehe [Status der List.entry.flag](workflowmanagement.html#status-der-list-entry-flag)).

#### List-Collection-Bundle

Eine Version einer Liste wird durch ein Collection Bundle repräsentiert. Dieses enthält die *List*-Ressource sowie sämtliche von ihr referenzierten Ressourcen. Das Collection Bundle dient sowohl der Persistierung einer Listenversion nach einem [List-Write](interactions.html#list-write) als auch der Auslieferung einer Liste im Rahmen eines [List-Read](interactions.html#list-read).

##### Persistiertes List-Collection-Bundle

Nach erfolgreichem Abschluss eines [List-Write](interactions.html#list-write) übernimmt die Fachanwendung die im *List-Transaction-Bundle* übermittelten Änderungen und erstellt ein **List-Collection-Bundle zur Persistierung**:

Dieses bildet die vom GDA übermittelte Liste unverändert ab, d.h. insbesondere ohne Anpassung der *List.entry.flag*-Werte oder Entfernung von mit *removed* gekennzeichneten Listeneinträgen. Zusätzlich enthält das Bundle sämtliche referenzierte Ressourcen. Dadurch bleibt der vollständige Zustand der Liste zum Zeitpunkt des Schreibvorgangs für historische Abfragen erhalten.


##### Auslieferungs-List-Collection-Bundle

Im Rahmen eines [List-Read](interactions.html#list-read) erstellt die Fachanwendung ein **Auslieferungs-List-Collection-Bundle** auf Basis des zuletzt persistierten List-Collection-Bundles.

Dabei werden die Inhalte wie folgt aufbereitet:

- Listeneinträge mit *List.entry.flag = new* oder *changed* werden auf *unchanged* gesetzt.
- Listeneinträge mit *List.entry.flag = removed* werden aus der ausgelieferten Liste entfernt.
- Wurden alle Listeneinträge entfernt, wird *List.emptyReason* auf *nilknown* gesetzt, um zu kennzeichnen, dass die Liste bewusst keine Einträge des durch *List.code* definierten Listentyps enthält.