Feature: recently viewd

	In order the application to be easier to use
	the User can browse among every recently visited 

	Scenario: browse among recently viewed places
		Given that every <service> User visits is saved in the internal storage  
		And the user wants to view all the recently visited <services>
		Then the User should be able to browse among these <services>

	Scenario: first time using the application
		Given that it is the first time the User uses the application
		Then the User should see a pop up message telling"Let's take a tour"
		And view random choices of destinations




