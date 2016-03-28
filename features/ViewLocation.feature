Feature: Allow a user to view details of a location they find on the map
  

Scenario: View location details from visit
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And the following locations are in the database:
    | name                  |     
    | The University of Iowa    |
    And the following visits are in the database:
    | user_id   | location_id   | start_date    | end_date  |
    | 1         | 1             | "1999-1-1"    | "1999-1-1"|
    And I have logged in
    When I navigate to the "My Visits" page
    And I select "The University of Iowa"
    Then I should be shown "I've been here"
    
#needs point from google maps api, can't test    
@wip
@javascript
Scenario: View location details from map
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in