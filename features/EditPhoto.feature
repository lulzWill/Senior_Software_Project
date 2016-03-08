Feature: Allow a user to edit a photo
  
Scenario: User edits a photo
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I add a new photo with title "a title" and description "a description" from "new photo" page
    And I edit the photo with title "a title" to have new title "title2"
    Then I should be shown "Photo updated!"