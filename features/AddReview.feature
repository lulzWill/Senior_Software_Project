Feature: Allow a user to create a review for a visit

@wip
@javascript
Scenario: Add a new review from map search
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I choose to "Write a Review" for "The University of Iowa" from the map
    And I have filled out the form with start date "2000-1-1", end date "2000-1-1", rating "2" and comment "just ok"
    Then I should be shown "Review added!"
    
    
@wip
@javascript
Scenario: Add a new review from map search, but overlaps previous visit
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
    When I choose to "Write a Review" for "The University of Iowa" from the map
    And I have filled out the form with start date "2000-1-1", end date "2000-1-1", rating "2" and comment "just ok"
    Then I should be shown "already visited"
    
    
@wip
@javascript
Scenario: Add a new review from map search, invalid dates
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I choose to "Write a Review" for "The University of Iowa" from the map
    And I have filled out the form with start date "2000-2-2", end date "2000-1-1", rating "2" and comment "just ok"
    Then I should be shown "invalid dates"


Scenario: Add a new review to a visit that doesn't have a review yet
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
    When I view one of my visits and choose to "Add review"
    And I have filled out the form with rating "2" and comment "just ok"
    Then I should be shown "Review added!"



