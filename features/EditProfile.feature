Feature: Allow a user to edit their own profile
  
Scenario: Edit your profile as a user
    Given the following users are in the database:
    | email                   | user_id       |password   | first_name | last_name | gender |
    | a@b.com                 | fake_user     |fakepass   | fake_first | fake_last | male   |

    And I have logged in
    When I navigate to the "Edit Profile" page
    Then I change "gender" to "female"
    Then I should see "Successfully updated profile!" and ""