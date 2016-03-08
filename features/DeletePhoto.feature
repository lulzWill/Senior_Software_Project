Feature: Allow a user to delete a photo
@javascript   
Scenario: User deletess a photo from that photo's page
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I add a new photo with title "a title" and description "a description" from "new photo" page
    And I delete a photo with title "a title"
    Then I should be shown "Photo deleted!"