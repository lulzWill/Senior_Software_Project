Feature: Allow a user to add a friend

@javascript
Scenario: Add a friend
  Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    | b@c.com                 | fake_user2    |fakepass   |
  And I have logged in

  When I go to "fake_user2"'s profile
  And I click the "add_friend_submit" button
  Then I should be shown "Added fake_user2 as a friend!"
  Then I log into the second account
  When I go to "fake_user"'s profile
  Then I click the "add_friend_submit" button
  Then I should be shown "Added fake_user as a friend!"