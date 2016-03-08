Feature: Allow a user to view albums they have added
  

Scenario: View albums added as a user 
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    Given the following albums are in the database:
    | title                   | description      |cover      |
    | test                    | fake_user        |1          |
    And I have logged in
    When I add a new album with title "test" and description "a description" from "new album" page
    And I view the "my albums" page
    Then I should be shown "test"