Instance: AtElgaCoreList01
InstanceOf: AtElgaCoreList   
Title: "Beispiel einer leeren ELGA Core Liste"
Description: "Beispiel einer leeren ELGA Core Liste (emptyReason notstarted)"
Usage: #example

* identifier.value = "123"
* status = #current
* mode = #working
* code = $cs-sct#736378000 // "Medikationsplan" 
* subject = Reference(AtElgaCorePatientExample01)
* date = "2026-02-27T08:00:00+00:00" 
* source = Reference(AtElgaCoreDevice01)
* emptyReason = $cs-list-empty-reason#notstarted
