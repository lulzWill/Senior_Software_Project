Feature: Allow a user to view their own and other users' profiles

Background: users in the user table 
    Given the following users are in the database:
        | email                   | user_id        |password   | first_name  | last_name  | gender |
        | a@b.com                 | fake_user      |fakepass   | fake_first  | fake_last  | male   |
        | c@d.com                 | fake_user2     |fakepass   | fake_first2 | fake_last2 | male   |
     
Scenario: View your profile as a user
    And I have logged in
    When I navigate to the "View Profile" page
    Then I should see "fake_user" and "a@b.com"
    
Scenario: View another user's profile as a user
    And I have logged in
    When I navigate to the page of "fake_user2"
    Then I should see "fake_user2" and "c@d.com"