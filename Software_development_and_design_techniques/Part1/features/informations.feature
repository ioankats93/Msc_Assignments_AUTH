Feature: informations

	Background:
		Given that the User is logged in 

	Scenario: telephone informations
		Given that the User found a service related to his trip 
		Then the User should be able to view the telephone number of this service in format
			|name|service-hours|telephone|

	Scenario: Website informations
		Given that the User found a service related to his trip 
			Then the User should be able to view the Wensite of this service

	Scenario: Email informations
		Given that the User found a service related to his trip 
		Then the User should be able to view the contact email of this service in format
			|name|service-hours|e-mail|

	Scenario: No informations
		Given that the User found a service related to his/hers trip
		And there is no telephone, email, website informations
		Then the User should see a pop up message telling "There is no contact informations"