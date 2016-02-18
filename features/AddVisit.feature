Feature: Allow a user to add a visit
  
Scenario: Add a visit
  Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
  And I have logged in
  #needs map data to complete
  When I search the map for "University of Iowa" and click "Mark as visited"
  And I have filled out the form with "10/10/2015" to "11/11/2015"
  Then I should be shown "You marked the location!"
  
