Given /the following visits are in the database:/ do |visits_table|
    visits_table.hashes.each do |visit|
        Visit.create(visit)
    end
end

When /^I have filled out the form with "(.*?)"$/ do |start_date|
    fill_in 'start_date', :with => Date.parse(start_date)
    click_button 'visit_submit'
end

When /^I view one of my visits and choose to "(.*?)"$/ do |link|
    visit visits_path
    first('.visit').click_link("Visit Info")
    click_link link
end

