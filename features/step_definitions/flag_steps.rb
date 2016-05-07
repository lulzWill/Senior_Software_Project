When /^I click "(.*?)"$/ do |button|
   click_button button
end

When /^I navigate to that photo page$/ do
    visit photo_path(1)
end

Then /^flag button should have text "(.*?)"$/ do |text|
   expect(find('#flag_review_button').value).to eq(text) 
end