Given /the following reviews are in the database:/ do |reviews_table|
    reviews_table.hashes.each do |review|
        Review.create(review)
    end
end

When /^I have filled out the form with rating "(.*?)" and comment "(.*?)"$/ do |rating, comment|
    select rating, :from => 'review_rating'
    fill_in 'comment', :with => comment
    click_button 'review_submit' 
end