Feature: rate a service

	Background:
		Given the id of a service

	Scenario: rate a service
		When I submit a rate for a service
		| date      | 8/2/2017 12:32 |
		| rate      | 4              |
    | rate_id   | 35             |
		Then I should be prompted to review the service
		Then I should see a success message saying "rate successfully added"

	Scenario: update rate
		When I update a rate by its id
		| id 		 | 189         			|
		And I specify the following rate
		| date      | 8/2/2017 12:35 |
		| rate      | 4.6            |
    | rate_id   | 35             |
		Then I should see a success message saying "rate updated"


  Scenario: Rate a non existing service
		When I submit a rate
    | date      | 8/2/2017 12:32 |
		| rate      | 4              |
    | rate_id   | 35             |
		# And the service does not exist
		Then I should see "service doesn't exist"
