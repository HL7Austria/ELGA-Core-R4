/*##############################################################################
# Type:       FSH-File for an FHIR® Profile
# About:      ELGA FHIR® Core Profile for List.
# Created by: ELGA GmbH, Austria
##############################################################################*/

Profile: AtElgaCoreList
Parent: List
Id: at-elga-core-list
Title: "AT ELGA Core List Profil"
Description: "Generische Liste für ELGA-Anwendungen. Diese enthält 0..* Einträge (List.entry), wobei jedes Entry genau eine Referenz auf einen Listeneintrag (List.entry.item) enthält.
Die Reihenfolge der Einträge der Listeneinträge ist relevant und wird duch die Reihung der Eintries festgelegt werden. Jeder Listeneintrag enthält im Element List.entry.flag den Änderungsstatus des jeweiligen Eintrags."

* identifier 1..1 MS
* identifier ^short = "Logischer Identfier der Liste zur Integritätsprüfung beim Schreibvorgang."

* status 1..1 MS
* status from ElgaListStatusVS (required)
* status ^short = "Status der Liste. Mögliche Ausprägungen: [current | retired] Bedeutung: current: default | retired: nach Ableben des Patienten bis Ende der Aufbewahrungsfrist"

* mode 1..1 MS
* mode = #working (exactly)
* mode ^short = "Die Liste wird laufend gepflegt, hat daher den fixen Wert: working."

* title 0..0
* title ^short = "Die Liste hat keinen Titel."

* code 1..1 MS 
* code ^short = "Code, der den Typ der Liste beschreibt."

* subject 1..1 MS
* subject only Reference(AtElgaCorePatient) 
* subject ^short = "Patient, für den die Liste geführt wird, der über den 
Zentralen Patientenindex identifizierbar und Teilnehmer der ELGA-Anwendung ist."

* encounter 0..0
* encounter ^short = "Es wird kein Behandlungskontext dokumentiert."

* date 1..1 MS
* date ^short = "Datum der letzten Aktualisierung der Liste."

* source 1..1 MS
* source only Reference(AtElgaCorePractitioner or AtElgaCorePractitionerRole or Device or AtElgaCorePatient)  
* source ^short = "Person, die die Liste erstellt hat und für den Inhalt verantwortlich ist. 
Im Falle eines GDA: eindeutig identifiziert über den GDA-Index und berechtigt auf die ELGA-Anwendung 
des Patienten zuzugreifen. Im Falle eines Patienten: eindeutig identifiziert durch den ZPI."

* orderedBy 0..0 
* orderedBy ^short = "Die Reihenfolge der Einträge wird über die List.entries durch den Ersteller vorgegeben."

* note 0..0 
* note ^short = "Keine Freitext-Anmerkungen auf Listenebene." 

// --- Entries ---
* entry 0..* MS
* entry ^short = "Die Reihenfolge der Listeneinträge ist fachlich relevant und wird durch den Ersteller durch die Reihung der Eintries festgelegt."

* entry.flag 1..1 MS
* entry.flag from ElgaListEntryFlagVS
* entry.flag ^short = "Kennzeichnet die Art der Änderung des Listeneintrags: [New | Unchanged | Changed | Removed] Bedeutung: New: Neuer Eintrag wird hinzugefügt | Unchanged: Bestehender Eintrag wird beibehalten und zur Kenntnis genommen | Changed: Bestehender Eintrag wird geändert | Removed: Bestehender Eintrag wird entfernt"

* entry.deleted 0..0
* entry.deleted ^short = "Keine Verwendung in der ELGA Core List (da list.mode immer working)."

* entry.date 0..0
* entry.date ^short = "Kein Datum der Aufnahme bzw. Änderung des Eintrags im List.entry. Das Datum ist nur im in der referenzierten Ressource ersichtlich."

* entry.item 1..1 MS
* entry.item ^short = "Referenz auf einen Eintrag."

* emptyReason 0..1 MS
* emptyReason from ElgaListEmptyReasonVS (required)
* emptyReason ^short = "Begründung, warum die Liste leer ist. Mögliche Ausprägungen: [notstarted |  nilknown] Bedeutung: notstarted: Intitalzustand - noch nie befüllt | nilknown: Die Liste wurde explizit geleert."