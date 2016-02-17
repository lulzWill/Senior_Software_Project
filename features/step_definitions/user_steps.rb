When /^I have successfully signed up as a "(.*?)"$/ do |position|
  visit new_user_path
  fill_in 'signup_email', :with => "fake@fake.com"
  fill_in 'signup_id', :with => "fake_user"
  fill_in 'signup_pass', :with => "fakepass"
  fill_in 'signup_pass_conf', :with => "fakepass"

  click_button 'signup_submit'
end

When /^I have filled out the sign up form with mismatching passwords$/ do
  visit new_user_path
  fill_in 'signup_email', :with => "fake@fake.com"
  fill_in 'signup_id', :with => "fake_user"
  fill_in 'signup_pass', :with => "fakefake"
  fill_in 'signup_pass_conf', :with => "fakefaker"
  click_button 'signup_submit'
end

When /^I have filled out the sign up form with a bad email$/ do
  visit new_user_path
  fill_in 'signup_email', :with => "fake"
  fill_in 'signup_id', :with => "fake_user"
  fill_in 'signup_pass', :with => "fakefake"
  fill_in 'signup_pass_conf', :with => "fakefake"
  click_button 'signup_submit'
end

When /^I have filled out the sign up form with a short password$/ do
  visit new_user_path
  fill_in 'signup_email', :with => "fake@fake.com"
  fill_in 'signup_id', :with => "fake_user"
  fill_in 'signup_pass', :with => "fake"
  fill_in 'signup_pass_conf', :with => "fake"
  click_button 'signup_submit'
end

When /^I have filled out the sign up form with a long password$/ do
  visit new_user_path
  fill_in 'signup_email', :with => "fake@fake.com"
  fill_in 'signup_id', :with => "fake_user"
  fill_in 'signup_pass', :with => "fakelongpasswordsarebad"
  fill_in 'signup_pass_conf', :with => "fakelongpasswordsarebad"
  click_button 'signup_submit'
end

Then /^I should be shown "(.*?)" confirmation on the homepage$/ do |position|
  expect(page.text).to match(/You have successfully signed up as a #{position}/)
end

Then /^I should be shown a "(.*?)" error message$/ do |error_type|
  expect(page.text).to match(/ERROR:.*#{error_type}/)
end