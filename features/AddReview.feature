Feature: Allow a user to create a review for a visit
  
Scenario: Add a new review to a visit that dosen't have a review yet
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
    
    
    
Scenario: Add a new review from map search
    