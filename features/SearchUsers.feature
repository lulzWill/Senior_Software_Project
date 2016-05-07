Feature: Allow a user to search for other user's profiles
  
@javascript
Scenario: Search from search bar (ignoring autocomplete)
    Given the following users are in the database:
    | email                 | user_id       |password   |
    | a@b.com               | fake_user     |fakepass   |
    | a@c.com               | fake_user2    |fakepass   |
    And I have logged in
    When I search for "fake"
    Then I should be shown "fake_user2"
    

#can't test due to javascript errors
#@javascript 
#Scenario: Search from search bar (using autocomplete)
#    Given the following users are in the database:
#    | email                 | user_id       |password   |
#    | a@b.com               | fake_user     |fakepass   |
#    | a@c.com               | fake_user2    |fakepass   |
#    And I have logged in
#    When I search for "fake" using autocomplete
#    And I wait for "3" seconds
#    Then I should be shown "fake_user2"
    