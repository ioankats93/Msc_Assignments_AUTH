Feature: pay for booking

	Background:
		Given the id of an unpaid booking

	Scenario: pay for a booking
	Possible payment options are 'credit', 'paypal'
		When I submit a payment for an order
		| amount | 1200           |
		| date   | 12/2/2018      |
		| type   | 'credit'       |
		Then I should be prompted to review the booking

	Scenario: pay for booking less or more money
		When I submit a wrong payment for a booking
		Then I should see a message saying "wrong amount"
		And I should be prompted to submit a payment
		And I should be prompted to review the booking
