Feature: Service

	#GET, PUT /services/{service_id}

	Background:
		Given that the User is logged in 

	Scenario: Service Hotel
		Given that the User searches for a Hotel to stay
		And the User has the option to set the distance in which the Hotel should be
		And the User has the option to set the price range in which the Hotel should be
		Then a list of relevant Hotels appears with the following format
			|name|reviews|price|
		And the User has the option to view a Hotel

	Scenario: Service Restaurant
		Given that the User searches for a place to eat
		And the User has the option to set the distance in which the Restaurant should be
		And the User has the option to set the price range in which the Restaurant should be
		Then a list of relevant Restaurants appears with the following format
			|name|reviews|price|
		And the User has the option to view a Restaurant

	Scenario: Service Things to Do
		Given that the User searches for things to do
		And the User has the option to set the distance for this activity
		And the User has the option to set the price range for this activity
		Then a list of relevant Activities appears with the following format
			|name|reviews|price|
		And the User has the option to view an Activity

	Scenario: Service Flight
		Given that the User searches for a Flight
		And the User has the option to set the data for the flight
		And the User has the option to set the price range for this flight
		Then a list of relevant Flights appears with the following format
			|name|dates|price|
		And the User has the option to view a flight

	Scenario: Service misspelled
		Given that the User misspelled the service
		Then User should see a message saying "You probably misspelled"
		And view a list of relevant service's names

	Scenario: Service does not exists
		When User searches for a service related to his trip
		And the Service does not exist
		Then the User should see a pop up message telling "This <service> does not exist"

