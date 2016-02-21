When /^I choose to "(.*?)" for "(.*?)" from the map$/ do |link, location|
    fill_in 'pac-input', :with => location
    #press enter
    find(:id, 'pac-input').native.send_keys("\n")
    #click result icon
    find("div[title='"+location+"']").click
    #click link
    click_link link
end