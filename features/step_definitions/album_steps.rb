When /^I add a new album with title "(.*?)" and description "(.*?)" from "(.*?)" page$/ do |title, description, page|
    if page == 'new album'
        visit new_album_path
    end
    fill_in 'title', :with => title 
    fill_in 'description', :with => description 
    click_button 'album_submit'
end

When /^I edit the album with title "(.*?)" to have new title "(.*?)"$/ do |title, new_title|
    click_button 'Edit Album'
    fill_in 'title', :with => new_title 
    click_button 'album_submit'
    
end

When /^I delete an album with title "(.*?)"$/ do |title|
    click_button 'Delete Album'
    page.driver.browser.switch_to.alert.accept
end

When /^I view the "(.*?)" page$/ do |page|
    if page == 'my albums'
        visit albums_path
    end
end