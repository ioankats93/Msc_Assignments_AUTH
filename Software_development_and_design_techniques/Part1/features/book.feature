Feature: reserve

	Background:
		Given that the User found service
		And there is internet connection

	Scenario: new Hotel room
		Given that the User has found a Hotel
		When the User books a room
		Then a new reservation is created
		And the User has the option to pay for the reservation
		And the User has the option to cancel the reservation
		And the User has the option to update the reservation

	Scenario: cancel submitted reservation
		Given that the user has a reservation
		When he/she cancels the reservation
		Then he/she should see a success message saying "Reservation canceled"
		And he/she should be prompted to search for more Hotels

	Scenario: update unpaid reservation
		Given that the user has a reservation
		And the reservation status is "unpaid"
		When the user updates the reservation with guests
			|qt|
		Then he/she should see a success message saying "Reservation updated"
		And he/she should be prompted to pay
		And he/she has the option to review the reservation
		And he/she has the option to cancel the reservation
		And he/she has the option to update the reservation

	Scenario: view paid reservation
		Given that User has a reservation
		When he/she requests the reservation by it's id
		Then he/she can view the details of the reservation

	Scenario: reservation doesn't exist
		Given a reservation doesn't exist
		When the user requests,delete,update that reservation
		Then the user should see a message "That reservation doesn't exist"