Feature: Allow a user to sign up for the website
  
@javascript
Scenario: Sign up student
  When I have successfully signed up as a "User"
  Then I should be shown "User" confirmation on the homepage
  
@javascript
Scenario: Mismatching Passwords
  When I have filled out the sign up form with mismatching passwords
  Then I should be shown a "Password" error message
  
@javascript
Scenario: Wrong Email Format
  When I have filled out the sign up form with a bad email
  Then I should be shown a "Email" error message
  
@javascript
Scenario: Password too short
  When I have filled out the sign up form with a short password
  Then I should be shown a "Password" error message
  
@javascript
Scenario: Password too long
  When I have filled out the sign up form with a long password
  Then I should be shown a "Password" error message