Feature: user

	# POST /basket
	# GET, PUT /basket/{basket_id}

	Scenario: new user
		When I submit a user:
      | username      | 'Ioa'		                    	|  								|
      | first name  	| 'Ioannis'											|									|
      | last name 		| 'Katsikavelas' 								|									|
      | email					| 'katsikave@ece.auth.gr'				|									|
      | password      | ********               				| min length of 8 |
      | id            | 250                   				|                 |
      | date of birth | 12/02/1993                  	|  								|
      | sex           | 'male'                      	|   							|
      | photo         | 'http://photo.com/myphoto'  	|   							|
		Then I should see
      | username      | 'Ioa'		                    	|  								|
      | first name  	| 'Ioannis'											|									|
      | last name 		| 'Katsikavelas' 								|									|
      | email					| 'katsikave@ece.auth.gr'				|									|
      | password      | ********               				| min length of 8 |
      | id            | 250                   				|                 |
      | date of birth | 12/02/1993                  	|  								|
      | sex           | 'male'                      	|   							|
      | photo         | 'http://photo.com/myphoto'  	|   							|
		And I should be prompted to create a user
		And I should have the option to view the user
		And I should have the option to request  search
		And I should have the option to make a booking
		And I should have the option to make a comment
		And I should have the option to make a rate
		And I should have the option to remove a service

	Scenario: update user
		Given I have a user
		When I update the user by it's id
		And I submit new user in this format
      | username      | 'Ioa'		              			  |  								|
		Then I should see
      | username      | 'Ioannis93'		                |  								|
      | first name  	| 'Ioannis'											|									|
      | last name 		| 'Katsikavelas' 								|									|
      | email					| 'katsikave@ece.auth.gr'				|									|
      | password      | ********               				| min length of 8 |
      | id            | 250                   				|                 |
      | date of birth | 12/02/1993                  	|  								|
      | sex           | 'male'                      	|   							|
      | photo         | 'http://photo.com/myphoto'  	|   							|
		And I should be prompted to view the user

	Scenario: retrieve user
		Given I have a user
		When I retrieve the user by it's id
		Then I should see a user:
      | username      | 'Ioa'		                    	|  								|
      | first name  	| 'Ioannis'											|									|
      | last name 		| 'Katsikavelas' 								|									|
      | email					| 'katsikave@ece.auth.gr'				|									|
      | password      | ********               				| min length of 8 |
      | id            | 250                   				|                 |
      | date of birth | 12/02/1993                  	|  								|
      | sex           | 'male'                      	|   							|
      | photo         | 'http://photo.com/myphoto'  	|   							|
		And I should have the option to view the service
