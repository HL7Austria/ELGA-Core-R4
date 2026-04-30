Instance:    AtElgaCoreOrganizationExample01
InstanceOf:  AtElgaCoreOrganization
Description: "Beispiel einer Organisation in ELGA"
Usage:       #example

* name = "Amadeus Spital"
* type = https://termgit.elga.gv.at/ValueSet/hl7-at-organizationtype#300 "Allgemeine Krankenanstalt"

* identifier[GDA-OID].value = "urn:oid:1.2.40.0.34.99.4613.3"
* identifier[GDA-OID].system = "urn:ietf:rfc:3986"
* identifier[GDA-OID].assigner.display = "Bundesministerium für Gesundheit"
* identifier[KANR].value = "K101"
* identifier[KANR].system = "urn:oid:1.2.40.0.34.4.10"
* identifier[KANR].assigner.display = "Österreichisches Bundesministerium für Gesundheit"
* identifier[VPNR][0].value = "123456789"
* identifier[VPNR][0].system = "urn:oid:1.2.40.0.10.1.4.3.2"
* identifier[VPNR][0].assigner.display = "Dachverband der österreichischen Sozialversicherungsträger"

* address = HL7ATCoreAddressExample10

Instance:    HL7ATCoreAddressExample10
InstanceOf:  HL7ATCoreAddress
Description: "Example for the usage of the HL7 AT Core Address Profile"
Usage:       #inline
* use = http://hl7.org/fhir/address-use#work
* type = http://hl7.org/fhir/address-type#both
* line = "Mozartgasse 1-7 Haupteingang" 
* line.extension[street].valueString = "Mozartgasse"
* line.extension[streetNumber].valueString = "1-7"
* line.extension[floorDoorNumber].valueString = "Haupteingang"
* line.extension[additionalInformation].valueString = "Barrierefreier Zugang"
* city = "St. Wolfgang"
* state = "Salzburg"
* postalCode = "5350"
* country = "AUT"