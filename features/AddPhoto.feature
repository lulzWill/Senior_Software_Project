Feature: Allow a user to add a photo
  
Scenario: User adds a photo
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I add a new photo with title "a title" and description "a description" from "new photo" page
    Then I should be shown "Photo added!"
    
Scenario: User adds a photo to an album
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And I have logged in
    When I add a new photo with title "a title" and description "a description" from "album" page
    Then I should be shown "Photo added!"