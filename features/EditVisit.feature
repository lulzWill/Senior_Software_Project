Feature: Allow a user to edit visit information

Scenario: Edit a visit
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
    When I view one of my visits and choose to "Edit date"
    And I have filled out the form with "10/10/2015" to "11/11/2015"
    Then I should be shown "Visit updated!"
    
Scenario: Attempt to edit a visit, overlaps previous visit
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And the following locations are in the database:
    | name                  |     
    | University of Iowa    |
    And the following visits are in the database:
    | user_id   | location_id   | start_date    | end_date  |
    | 1         | 1             | "1999-1-1"    | "2001-1-1"|
    And I have logged in
    When I view one of my visits and choose to "Edit date"
    And I have filled out the form with "1000-11-11" to "3000-1-1"
    Then I should be shown "already visited"
    
@javascript
Scenario: Attempt to edit a visit, invalid dates
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And the following locations are in the database:
    | name                  |     
    | University of Iowa    |
    And the following visits are in the database:
    | user_id   | location_id   | start_date    | end_date  |
    | 1         | 1             | "1999-1-1"    | "1999-1-1"|
    And I have logged in
    When I view one of my visits and choose to "Edit date"
    And I have filled out the form with "2000-11-11" to "2000-1-1"
    Then I should be shown "Invalid dates"