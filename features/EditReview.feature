Feature: Allow a user to edit a review

Scenario: Edit a review
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And the following locations are in the database:
    | name                  |     
    | University of Iowa    |
    And the following visits are in the database:
    | user_id   | location_id   | 
    | 1         | 1             | 
    And the following reviews are in the database:
    | user_id   | location_id   | visit_id  | rating    | comment   |
    | 1         | 1             | 1         | 4         | good      |
    And I have logged in
    When I view one of my visits and choose to "Edit review"
    And I have filled out the form with rating "5" and comment "just ok"
    Then I should be shown "Review updated!"