Given /the following locations are in the database:/ do |locations_table|
    locations_table.hashes.each do |location|
        Location.create(location)
    end
end

When /^I select "(.*?)"$/ do |link|
    click_link link
end