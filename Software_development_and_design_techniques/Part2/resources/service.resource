Feature: service

	# POST /service
	# GET, PUT, DELETE /service/{service_id}

	Scenario: retrieve service
		When I retrieve a service by its id
		Then I should see the service as follows:
    | id              | 30                       		|
		| category        | 'Hotel'                	 		|
		| servicename    	| 'Grand Hotel'         	 		|
		| description     | 'Grand hotel near Larisa'		|
		| date of release | 05/06/2010               		|
		| location    		| 'Larisa'								 		|
		| telephone		    | '2410228811'						 		|
		| email    				| 'grandhotel@info.gr'		 		|
		| tag             | 'hotels'	               		|
		| photo        		| 'http://photo.com/myphoto'  |
    | cost            | 1500.1                      |
		And I should see "service retrieved"

	Scenario: remove service from site
		When I delete a service
		| servicename     | 'Grand Hotel'    |
		| category        | 'Hotel'          |
		Then I should see "deleted!"
    And I should be prompted to create a service

	Scenario: add service to site
		When I add a new service:
    | id              | 30                       		|
		| category        | 'Hotel'                	 		|
		| servicename    	| 'Grand Hotel'         	 		|
		| description     | 'Grand hotel near Larisa'		|
		| date of release | 05/06/2010               		|
		| location    		| 'Larisa'								 		|
		| telephone		    | '2410228811'						 		|
		| email    				| 'grandhotel@info.gr'		 		|
		| tag             | 'hotels'	               		|
		| photo        		| 'http://photo.com/myphoto'  |
    | cost            | 1500.1                      |
		Then I should see the created service:
    | id              | 30                       		|
		| category        | 'Hotel'                	 		|
		| servicename    	| 'Grand Hotel'         	 		|
		| description     | 'Grand hotel near Larisa'		|
		| date of release | 05/06/2010               		|
		| location    		| 'Larisa'								 		|
		| telephone		    | '2410228811'						 		|
		| email    				| 'grandhotel@info.gr'		 		|
		| tag             | 'hotels'	               		|
		| photo        		| 'http://photo.com/myphoto'  |
    | cost            | 1500.1                      |
    Then I should see "Successfully created! !"
    And I should be prompted to create or update a service

	Scenario: update service
		# Given an existing service
		When I update the service:
		| servicename | 'NOLAN'                |
		| description | '3 Michelin stars'     |
		| category    | 'Restaurant'           |
		And I specify it's description
		Then I should see the updated service
    | servicename | 'NOLAN'                |
		| description | '2 Michelin stars'     |
		| category    | 'Restaurant'           |
    Then I should see "Successfully updated! !"
    And I should be prompted to create or update a service

	Scenario: service doesn't exist
		Given that a service doesn't exist
		When I try to delete or retrieve or edit the service
		Then I should see a message telling me "the service doesn't exist"
    And I should be prompted to create a service

	Scenario: not logged in
		Given that I'm not logged in
		When I try to add or delete or update a service
		Then I should see a message telling me "Not allowed"
