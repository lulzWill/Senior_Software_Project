Feature: Allow a user to view their trips
  

Scenario: View all trips from the trip index
    Given the following users are in the database:
    | email                   | user_id       |password   |
    | a@b.com                 | fake_user     |fakepass   |
    And the following trips are in the database:
    | name              | main_user_id  | start_date    | end_date  |
    | "current_trip_1   | 1             | "1999-1-1"    | "2100-1-1"|
    | "future_trip_1   | 1             | "2999-1-1"    | "3100-1-1"|
    | "past_trip_1   | 1             | "1199-1-1"    | "1300-1-1"|
    And I have logged in
    When I navigate to the "Trips" page
    Then I should be shown "current_trip_1"
    And I should be shown "future_trip_1"
    And I should be shown "past_trip_1"
    
