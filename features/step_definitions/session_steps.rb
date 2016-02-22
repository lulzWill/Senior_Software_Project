Given /the following users are in the database:/ do |users_table|
    users_table.hashes.each do |user|
        User.create(user)
    end
end

Given /^I have logged in$/ do
    visit new_session_path
    fill_in 'login_user_id', :with => "fake_user"
    fill_in 'login_password', :with => "fakepass"
    click_button 'login_button'
end

Then /^I should be shown "(.*?)"$/ do |message|
   expect(page.text).to match(/#{message}/) 
end

When /^I navigate to the "(.*?)" page$/ do |page|
   click_link "My Visits"
end