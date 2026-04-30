Instance:    AtElgaCorePractitionerRoleExample01
InstanceOf:  AtElgaCorePractitionerRole
Description: "Beispiel einer PractitionerRole in ELGA"
Usage:       #example

* active = true
* code = https://termgit.elga.gv.at/ValueSet/hl7-at-practitionerrole#100 "Ärztin/Arzt für Allgemeinmedizin"
* practitioner = Reference(AtElgaCorePractitionerExample01)
* specialty[0] = http://snomed.info/sct#419772000 "Family practice"
* specialty[1] = http://snomed.info/sct#410005002 "Dive medicine"