Feature: Viewing the profile newsfeed

Scenario: View friend activity on their profile if friendship exists
  Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    | b@c.com                 | fake_user2    |fakepass   |
  And the following activities are in the database:
    | user_id   | username  | activity_type | data                                          |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
  And the following friendships are in the database:
    | user_id   | friend_id |
    | 1         | 2         |
    | 2         | 1         |
  And I have logged in
  When I navigate to the page of "fake_user2"
  Then I should be shown "added a visit"