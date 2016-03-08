Feature: Allow a user to delete an album
  
@javascript  
Scenario: User deletess an palbum from that album's page
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I add a new album with title "a title" and description "a description" from "new album" page
    And I delete an album with title "a title"
    Then I should be shown "Album Deleted"