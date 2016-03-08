When /^I add a new photo with title "(.*?)" and description "(.*?)" from "(.*?)" page$/ do |title, description, page|
    if page == 'new photo'
        visit new_photo_path
    end
    if page == 'album'
        visit new_album_path
        fill_in 'title', :with => "title" 
        fill_in 'description', :with => "description" 
        click_button 'album_submit'
        click_link 'Add Photos'
    end
    fill_in 'title', :with => title 
    fill_in 'description', :with => description 
    click_button 'picture_submit'
end

When /^I edit the photo with title "(.*?)" to have new title "(.*?)"$/ do |title, new_title|
    click_link 'Edit photo info'
    fill_in 'title', :with => new_title 
    click_button 'picture_submit'
    
end

When /^I delete a photo with title "(.*?)"$/ do |title|
    click_link 'Delete photo'
    page.driver.browser.switch_to.alert.accept
end