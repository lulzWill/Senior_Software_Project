Feature: Allow a user to flag an inappropriate photo
  
@javascript
Scenario: Flag inappropriate photo
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    | b@b.com                 | fake_user2     |fakepass   |
    And the following photos are in the database:
    | user_id   | 
    | 2         | 
    And I have logged in
    When I navigate to that photo page
    And I click "Flag Photo"
    And I wait for "3" seconds
    Then flag button should have text "Photo Flagged"