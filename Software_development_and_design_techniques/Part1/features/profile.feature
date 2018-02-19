Feature: profile
	
	# GET, PUT, DELETE /profiles/{profiles_id}

	Scenario: make a profile
		Given that User opens the application
		And that it is the first time that he/she opens it
		Then he/she should see a login screen 
		Then he/she should be prompted to make a registration
		Then he/she should be prompted to make a profile

	Scenario: edit a profile
		Given that the User is logged in
		Then he/she should be able to update his/hers profile	

	Scenario: upload a photo
		Given that the User is logged in
		Then he/she should be able to add, delete or update profile photo

	Scenario: View profile
		Given that the User is logged in
		Then he/she should be able to view profiles, photos of other Users
		
	Scenario: not logged in
		Given that User is not logged in
		When He/She try to add, delete or update profile informations
		Then He/She should see a message telling "You have to be logged in"