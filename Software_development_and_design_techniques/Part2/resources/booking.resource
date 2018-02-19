Feature: booking service

	# POST /booking
	# GET, PUT, DELETE /booking/{booking_id}

	Scenario: book a service
		When I submit a booking for a service
		| amount | 150         			|
		| date   | 18/2/2018 12:32 	|
		| type   | 'credit'       	|
		Then I should see the message "booking created successfully"
		And I should be prompted to submit a payment
		And I have the option to review the booking
		And I have the option to cancel the booking
		And I have the option to update the booking

	Scenario: cancel submitted booking
		# Given I have booking
		When I cancel the booking
		Then I should see a success message saying "booking canceled"
		And I should be prompted to request a search

	Scenario: review booking
		When I request a booking by its id
		| id 		 | 150         			|
		Then I should see the message "booking found"
		Then I should see its information
		| amount | 150         			|
		| date   | 18/2/2018 12:32 	|
		| type   | 'credit'       	|
		And I have the option to update the booking

	Scenario: update unpaid service
		When I update a booking by its id
		And I specify the following booking
			| booking id      | 3433             |
			| date   	  | 05/06/2010       |
		Then I should see a success message saying "booking updated"
		And I should be prompted to submit a payment
		And I have the option to cancel the booking
		And I have the option to update the booking
