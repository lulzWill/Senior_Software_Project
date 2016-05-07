Feature: Viewing activity on the newsfeed

Scenario: View friend activity on homepage newsfeed
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
  Then I should be shown "fake_user2 added a visit"
  

@javascript
Scenario: View next 10 friend activities on homepage newsfeed
  Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    | b@c.com                 | fake_user2    |fakepass   |
  And the following activities are in the database:
    | user_id   | username  | activity_type | data                                          |
    | 2         | fake_user2| review        | {review_id: 1, rating: 5, location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
    | 2         | fake_user2| visit         | {location_name: "test_place", location_id: 1} |
  And the following friendships are in the database:
    | user_id   | friend_id |
    | 1         | 2         |
    | 2         | 1         |
  And I have logged in
  When I click the "More news..." button
  And I wait for "3" seconds
  Then I should be shown "fake_user2 added a review"