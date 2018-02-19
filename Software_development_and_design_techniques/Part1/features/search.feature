Feature: Search 

	# GET /search?n={service_type} | collectionFormat = multi
	
	Scenario: Search for a service
		When User searches for a service related to his trip
		Then a list of relevant <services> appears with the following format
			|name|reviews|price|
		And User has the option to view a service

	Scenario: No internet
		When User searches for a service related to his trip
		And there is no internet connection
		Then the User should see a pop up message telling "There is no internet connection"
