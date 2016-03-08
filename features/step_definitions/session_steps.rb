Given /the following users are in the database:/ do |users_table|
    users_table.hashes.each do |user|
        User.create(user)
    end
end

Given /the following albums are in the database:/ do |albums_table|
    albums_table.hashes.each do |album|
        Album.create(album)
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

When /^I view the "(.*?)" page with title "(.*?)"$/ do |page,title|
    visit albums_path 
end