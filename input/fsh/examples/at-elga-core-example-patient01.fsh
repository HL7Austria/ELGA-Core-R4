Instance:    AtElgaCorePatientExample01
InstanceOf:  AtElgaCorePatient
Description: "Beispiel eines ELGA Patienten"
Usage:       #example

* name.family = "Mustermann"
* name.given = "Max"
* name.prefix = "DI"
* birthDate = 1900-01-01
* gender = http://hl7.org/fhir/administrative-gender#male 

* identifier[socialSecurityNumber].value = "1234010100"
* identifier[socialSecurityNumber].system = "urn:oid:1.2.40.0.10.1.4.3.1"
* identifier[socialSecurityNumber].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[socialSecurityNumber].type.coding.code = $HL7V2#SS
* identifier[socialSecurityNumber].type.coding.display = "Social Security number"
* identifier[socialSecurityNumber].assigner.display = "Dachverband der österreichischen Sozialversicherungsträger"
* identifier[bPK].value = "GH:oeLdSEb0l+8kSdJWjOYyYmnYki0="
* identifier[bPK].system = "urn:oid:1.2.40.0.10.2.1.1.149"
* identifier[bPK].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[bPK].type.coding.code = $HL7V2#NI
* identifier[bPK].type.coding.display = "National unique individual identifier"
* identifier[bPK].assigner.display = "Bundesministerium für Inneres"
* identifier[localPatientId].value = "0815"
* identifier[localPatientId].system = "urn:oid:1.2.3.4.5"
* identifier[localPatientId].type.coding.system = "http://terminology.hl7.org/CodeSystem/v2-0203"
* identifier[localPatientId].type.coding.code = $HL7V2#PI
* identifier[localPatientId].type.coding.display = "Patient internal identifier"
* identifier[localPatientId].assigner.display = "Ein GDA in Österreich"