Feature: offline use

	In order the User to be able to use the application offline,
	the User can download maps and reviews of every city of his/hers choice

	Background:
		Given that the User found a destination 
		And there is internet connection

	Scenario: download the map
		Given that the User can view the city
		And he/she press the download button
		And he/she download the data of the city
		Then the User should be able to use that map and read reviews offline


