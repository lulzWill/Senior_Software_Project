Feature: Allow a user to add a visit
  
@wip
@javascript
Scenario: Add a visit
  Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
  And I have logged in
  #needs map data to complete
  When I choose to "Mark as Visited" for "The University of Iowa" from the map
  And I have filled out the form with "10/10/2015" to "11/11/2015"
  Then I should be shown "You marked the location!"
  
