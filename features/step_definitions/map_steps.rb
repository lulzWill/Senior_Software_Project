When /^I choose to "(.*?)" for "(.*?)" from the map$/ do |link, location|
    fill_in 'pac-input', :with => location
    #press enter
    find(:id, 'my_id').native.send_keys("\n")
    #click result icon
    find("div[title='Sam\'s Bistro']").click
    #click link
    click_link link
end