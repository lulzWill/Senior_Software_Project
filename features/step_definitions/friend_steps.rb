And /^I click the "(.*?)" button$/ do |button|
    click_button button
end

Then /^I log into the second account$/ do
    visit new_session_path
    fill_in 'login_user_id', :with => "fake_user2"
    fill_in 'login_password', :with => "fakepass"
    click_button 'login_button'
end

When /^I go to "(.*?)"'s profile$/ do |user|
    visit "/users/#{user}"
end


