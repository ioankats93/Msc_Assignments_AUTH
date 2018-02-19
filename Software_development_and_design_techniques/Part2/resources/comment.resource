Feature: comment service

	Background:
		Given the id of a service

	Scenario: comment a service
		When I submit a comment for a service
		| date       | 8/2/2017 12:32 |
		| comment    | 'a comment'    |
		| comment_id |  15						|
		Then I should be prompted to review the comment

	Scenario: review comment
		When I request a comment by its id
		| id 		 | 189         			|
		Then I should see its information
		| date       | 8/2/2017 12:32 |
		| comment    | 'a comment'    |
		| comment_id | 189						|
		And I have the option to update the comment

	Scenario: update comment
		When I update a comment by its id
		| id 		 | 189         			|
		And I specify the following comment
		| date       | 9/2/2017 12:32	|
		| comment    | '2 comment'    |
		| comment_id | 189						|
		Then I should see a success message saying "comment updated"

	Scenario: unauthorized comment
		When I submit a comment for a service
		# And the service does not exist
		Then I should see a message "Can not comment"
		And I should be prompted to search a service
