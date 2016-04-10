Feature: Viewing the location newsfeed

Scenario: View visits on location newsfeed
  Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    | b@c.com                 | fake_user2    |fakepass   |
  And the following friendships are in the database:
    | user_id   | friend_id |
    | 1         | 2         |
    | 2         | 1         |
  And the following locations are in the database:
    | name                      |     
    | The University of Iowa    |
  And the following visits are in the database:
    | user_id   | location_id   | start_date    | end_date  |
    | 2         | 1             | "1999-1-1"    | "1999-1-1"|
    | 1         | 1             | "1999-1-1"    | "1999-1-1"|
  And I have logged in
  When I navigate to the "My Visits" page
  And I select "The University of Iowa"
  Then I should be shown "fake_user2 visited this location"
  
  
Scenario: View reviews on location newsfeed
  Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    | b@c.com                 | fake_user2    |fakepass   |
  And the following locations are in the database:
    | name                      |     
    | The University of Iowa    |
  And the following visits are in the database:
    | user_id   | location_id   | start_date    | end_date  |
    | 2         | 1             | "1999-1-1"    | "1999-1-1"|
    | 1         | 1             | "1999-1-1"    | "1999-1-1"|
  And the following reviews are in the database:
    | user_id   | location_id   | visit_id  | rating    | comment   |
    | 2         | 1             | 1         | 4         | good      |
  And I have logged in
  When I navigate to the "My Visits" page
  And I select "The University of Iowa"
  Then I should be shown "Rated by: fake_user2"