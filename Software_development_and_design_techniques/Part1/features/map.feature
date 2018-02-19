Feature: map
	
	# GET, PUT, DELETE /trips/{trip_id}

	In order to be easier to use and more familiar to the user.
	The user should be able to save future trips on his/hers profile

	Background:
		Given that the User is logged in 

	Scenario: set places user wants to travel
		When User wants to plan a future trip
		And he/she knows the <destination> and the <dates>
		Then the User can save his/hers future trip on his/hers profile

	Scenario: edit places user wants to travel
		When User wants to edit any of his/hers future trips
		Then the User should be able to edit his/hers trips on his/hers profile
