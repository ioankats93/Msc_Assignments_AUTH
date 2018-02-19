Feature: Search services

	# GET /search?n={product_name}&c={category_name}

	Scenario: Search for a service
	The user is able to search for services in the website using servicename and/or category filter, view their general details
		When I search for a service by its servicename and/or its category
		| servicename     | 'Grand Hotel'     |
		| category        | 'Hotel'           |
		Then a list of relevant services appears with the following format
		| servicename       | price |
		| 'Grand Hotel'     | 1500  |
		And I have the option to view a service

		Scenario: Search for a service that does not exist
		The user is able to search for services in the website using servicename and/or category filter, view their general details
			When I search for a service by its servicename and/or its category
			| servicename     | 'Grand Hotel'     |
			| category        | 'Hotel'           |
			Then I should see a message telling me "the service doesn't exist"
			And I should be prompted to request a search

		Scenario: Search for a user
		The user is able to search for other user in the website using email, view their general details
			When I search for a user
			And i specify
			| email				    | 'ioan@ece.auth.gr'|
			Then I should see a success message saying "user successfully found"
			And I should be prompted to view the user

		Scenario: Search query has no results
			When I search
			And I specify for example
		 	| email				    | 'ioan@ece.auth.gr'|
			# And there are no results
			Then I should see 'none found'
