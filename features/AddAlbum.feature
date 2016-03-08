Feature: Allow a user to add an Album
  
Scenario: User adds an album
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I add a new album with title "a title" and description "a description" from "new album" page
    Then I should be shown "Album Added"
    
