Feature: Settings

	In order to be easier to use and more familiar to the user.
	The user should be able to personalize some of the applications settings

	Background:
		Given that the User is logged in 

	Scenario: Application language
		Given that the User wants to change the language of the app
		Then he/she should be able to choose one of the application's languages

	Scenario: Metric System
		Given that the User wants to change the metric system of the app
		Then he/she should be able to change them from the settings menu

	Scenario: Set alerts
		Given that the User wants to set alerts based on the application
		Then he/she should be able to set, edit alerts regarding the application

	Scenario: Feedback
		Given that the User has some ideas for making the app better
		And he wants to sent them to the developers team
		Then he should be able to feedback the application



