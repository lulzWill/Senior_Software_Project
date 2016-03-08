Feature: Allow a user to edit an album
  
Scenario: User edits an album
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I add a new album with title "a title" and description "a description" from "new album" page
    And I edit the album with title "a title" to have new title "title2"
    Then I should be shown "Album Updated"