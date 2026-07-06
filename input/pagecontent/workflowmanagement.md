### Überblick der Statusänderungen der List Ressource

#### Status des List.entry.flags

Ein Listeneintrag kann, abhängig vom jeweiligen Use case, unterschiedliche Status einnehmen. Dieser Status kann sowohl in den referenzierten Ressourcen selbst als auch auf List-Ebene im Element List.entry.flag dokumentiert werden.

Das *flag*-Element eines Entries der List-Ressource beschreibt die **Art der Änderung eines Eintrags auf Listenebene** und kann folgende Status einnehmen:
<br><br>

| List.entry.flag | Beschreibung |
|--------|------|
| **New** | Neuer Eintrag wird der Liste hinzugefügt |
| **Unchanged** | Bestehender Eintrag wird beibehalten/zur Kenntnis genommen |
| **Changed**  | Bestehender Eintrag wird geändert |
| **Removed**  | Bestehender Eintrag wird entfernt |

<br>
<div>{% include_relative plantuml/workflow_list_flag.svg %}</div>
<br>

#### Auswirkung der Zugriffsart auf List.entry.flags und Bundle-Inhalte

Je nach Zugriffsart (List-History-Read, List-Read oder List-Write) ergeben sich unterschiedliche Auswirkungen auf die Verarbeitung dieser Status sowie auf die enthaltenen Ressourcen in den jeweiligen Bundles (siehe [Transaktionen](interactions.html)).
<br>
<br>

| List.entry.flag | List-History-Read | List-Read | List-Write |
|--------|------|------|------|
| **new** |- List-Entries, die vom vorherigen GDA mit *new* geflaggt wurden, bleiben beim List-History-Read **unverändert**.<br>- Die neu hinzugefügten Ressourcen sind im Collection Bundle enthalten.|- List-Entries, die vom vorherigen GDA mit *new* geflaggt wurden, werden beim List-Read von der **Fachanwendung** als **unchanged** geflaggt.<br>- Die betreffenden Ressourcen sind im Collection Bundle enthalten.|- List-Entries, die beim schreibenden Zugriff vom aktuellen GDA mit *new* geflaggt wurden, werden dem Medikationsplan neu hinzugefügt.<br>- Die betreffenden Ressourcen müssen im Transaction Bundle **enthalten** sein.|
| **unchanged** |- List-Entries, die vom vorherigen GDA mit *unchanged* geflaggt wurden, bleiben beim List-History-Read **unverändert**.<br>- Die unveränderten Ressourcen sind im Collection Bundle enthalten. |- List-Entries, die vom vorherigen GDA als *unchanged* geflaggt wurden, bleiben beim List-Read von der Fachanwendung unverändert.<br>- Die betreffenden Ressourcen sind im Collection Bundle enthalten.|- List-Entries, die vom aktuellen GDA nicht verändert wurden, bleiben beim schreibenden Zugriff mit *unchanged* geflaggt. Sie gelten somit als zur Kenntnis genommen.<br>-  Die betreffenden Ressourcen sind nicht im Transaction Bundle enthalten, sondern werden in der Liste **nur referenziert**.|
|  **changed**  |- List-Entries, die vom vorherigen GDA mit *changed* geflaggt wurden, bleiben beim List-History-Read **unverändert**.<br>- Die geänderten Ressourcen sind im Collection Bundle enthalten.|- List-Entries, die vom vorherigen GDA mit *changed* geflaggt wurden, werden beim List-Read von der **Fachanwendung** als **unchanged** geflaggt.<br>- Die betreffenden Ressourcen sind im Collection Bundle enthalten. |- List-Entries, die vom aktuellen GDA mit *changed* geflaggt werden, wurden geändert.<br>- Die betreffenden Ressourcen müssen im Transaction Bundle **enthalten** sein.|
|  **removed**  |- List-Entries, die vom vorherigen GDA mit *removed* geflaggt wurden, bleiben beim List-History-Read **unverändert**.<br>- Die zum Entfernen markierten Ressourcen sind im Collection Bundle enthalten. |- List-Entries, die vom vorherigen GDA mit *removed* geflaggt wurden, werden beim List-Read von der **Fachanwendung entfernt**.<br>- Die betreffenden Ressourcen sind im Collection Bundle **nicht enthalten**.|- List-Entries, die beim schreibenden Zugriff vom aktuellen GDA mit *removed* geflaggt wurden, sollen aus der Liste entfernt werden.<br>- Die betreffenden Ressourcen werden u.a. mit dem entsprechenden Status geflaggt und müssen im Transaction Bundle **enthalten** sein. |

<!-- 
##### Konsistenzregeln zwischen List.entry.flags und MedicationRequest-Status

Da der Status eines Medikationsplaneintrags im Medikationsplan auf **zwei Ebenen** geführt wird (List.entry.flag und MedicationRequest.status), müssen diese beiden Ebenen zur Sicherstellung einer konsistenten Verarbeitung inhaltlich aufeinander abgestimmt sein. Die folgende Tabelle beschreibt die geltenden Konsistenzregeln zwischen List.entry.flag und MedicationRequest.status in Abhängigkeit vom jeweiligen Use Case:
<br><br>


<table>
  <colgroup>
    <col style="width: 30%">
    <col style="width: 20%"> 
    <col style="width: 20%">
    <col style="width: 30%">
  </colgroup>
  <thead>
    <tr>
      <th>Use Case</th>
      <th>List.entry.flag</th>
      <th>MedicationRequest-Status<br>(Planeintrag)</th>
      <th>Beschreibung</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="2"><span style="font-weight:normal">Neuen Planeintrag zum Medikationsplan hinzufügen</span></td>
      <td><span style="font-weight:bold">new</span></td>
      <td><span style="font-weight:bold">active</span></td>
      <td>
        <span style="font-weight:normal">Neuer Planeintrag wird erstellt und ist aktiv</span><br>
        <span style="font-weight:normal">- der Behandlungszeitraum kann in der Zukunft liegen</span>
      </td>
    </tr>
    <tr>
      <td><span style="font-weight:bold">new</span></td>
      <td><span style="font-weight:bold">on-hold</span></td>
      <td><span style="font-weight:normal">Neuer Planeintrag wird erstellt, wird aber pausiert</span></td>
    </tr>
    <tr>
      <td rowspan="2"><span style="font-weight:normal">Bestehenden Planeintrag im Medikationsplan beibehalten/zur Kenntnis nehmen</span></td>
      <td><span style="font-weight:bold">unchanged</span></td>
      <td><span style="font-weight:bold">active</span></td>
      <td>
        <span style="font-weight:normal">Bestehender Planeintrag bleibt unverändert</span><br>
        <span style="font-weight:normal">- der Behandlungszeitraum darf noch nicht abgelaufen sein</span>
      </td>
    </tr>
    <tr>
      <td><span style="font-weight:bold">unchanged</span></td>
      <td><span style="font-weight:bold">on-hold</span></td>
      <td>
        <span style="font-weight:normal">Bestehender Planeintrag bleibt unverändert pausiert</span><br>
        <span style="font-weight:normal">- der Behandlungszeitraum darf noch nicht abgelaufen sein</span>
      </td>
    </tr>
    <tr>
      <td rowspan="2"><span style="font-weight:normal">Bestehenden Planeintrag im Medikationsplan ändern</span></td>
      <td><span style="font-weight:bold">changed</span></td>
      <td><span style="font-weight:bold">active</span></td>
      <td><span style="font-weight:normal">Bestehender Planeintrag wird geändert</span></td>
    </tr>
    <tr>
      <td><span style="font-weight:bold">changed</span></td>
      <td><span style="font-weight:bold">on-hold</span></td>
      <td><span style="font-weight:normal">Bestehender Planeintrag wird geändert und pausiert</span></td>
    </tr>
    <tr>
      <td rowspan="3"><span style="font-weight:normal">Bestehenden Planeintrag aus Medikationsplan entfernen</span></td>
      <td><span style="font-weight:bold">removed</span></td>
      <td><span style="font-weight:bold">completed</span></td>
      <td><span style="font-weight:normal">Bestehender Planeintrag wird beendet. Die Therapie wurde wie geplant durchgeführt und ist abgeschlossen.</span></td>
    </tr>
    <tr>
      <td><span style="font-weight:bold">removed</span></td>
      <td><span style="font-weight:bold">stopped</span></td>
      <td><span style="font-weight:normal">Bestehender Planeintrag wird vor Ablauf des Behandlungszeitraums dauerhaft gestoppt. Die Medikation wurde, bevor alle geplanten Einnahmen oder Verabreichungen durchgeführt wurden, abgesetzt.</span></td>
    </tr>
    <tr>
      <td><span style="font-weight:bold">removed</span></td>
      <td><span style="font-weight:bold">entered-in-error</span></td>
      <td><span style="font-weight:normal">Bestehender Planeintrag wird aufgrund eines Fehlers storniert</span></td>
    </tr>
  </tbody>
</table>

<br> -->
