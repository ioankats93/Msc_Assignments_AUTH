Feature: Comment

	In order to be more familiar and community based application,
	The user should be able to interract with other users.

	Background:
		Given that the User is logged in 

	Scenario: Write a comment
		Given that the User wants to write a review for a service related to his/hers trip
		Then he/she should <search> for this service
		Then he/she should view this service
		And he/she should be able to write a comment

	Scenario: Upload a photo as comment
		Given that the User wants to write a review for a service related to his/hers trip
		Then he/she should <search> for this service
		Then he/she should view this service
		And he/she can upload a photo as comment in the following format:
			|title|description|photo|

	Scenario: Read a comment
		Given that the searching for a service related to his/hers trip
		And the User found a <service>
		And the User View the <service>
		Then the User should be able to read comments from other Users

	Scenario: Deleting other Users comment
		Given that the User is trying to delete a comment
		And that comment is not made by him/her
		Then the User should see a pop up message telling "You have no authority doing that"
		



