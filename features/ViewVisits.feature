Feature: Allow a user to view locations they have visited
  
Scenario: View visited locations as a user
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And the following locations are in the database:
    | name                  |     
    | University of Iowa    |
    And the following visits are in the database:
    | user_id   | location_id   | 
    | 1         | 1             |
    And I have logged in
    When I navigate to the "My Visits" page
    Then I should be shown "University of Iowa"