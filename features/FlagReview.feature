Feature: Allow a user to flag an inappropriate review
  
@javascript
Scenario: Flag inappropriate review
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    | b@b.com                 | fake_user2     |fakepass   |
    And the following locations are in the database:
    | name                      |     
    | The University of Iowa    |
    And the following visits are in the database:
    | user_id   | location_id   |
    | 2         | 1             |
    And the following reviews are in the database:
    | user_id   | location_id   | visit_id  | rating    | comment   |
    | 2         | 1             | 1         | 4         | good      |
    And I have logged in
    When I navigate to the "Review of UIowa" page
    And I click "Flag Review"
    And I wait for "3" seconds
    Then flag button should have text "Review Flagged"