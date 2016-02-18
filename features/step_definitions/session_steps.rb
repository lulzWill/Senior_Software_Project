Given /the following users are in the database:/ do |users_table|
    users_table.hashes.each do |user|
        User.create(user)
    end
end

Given /^I have logged in$/ do
    visit new_user_path
    fill_in 'user_id_nav', :with => "fake_user"
    fill_in 'password_nav', :with => "fakepass"
    click_button 'Login'
end

Then /^I should be shown "(.*?)"$/ do |message|
   expect(page.text).to match(/#{message}/) 
end