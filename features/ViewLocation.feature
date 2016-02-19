Feature: Allow a user to view details of a location they find on the map
  
Scenario: View location details as a user
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in