Given /the following activities are in the database:/ do |activities_table|
    activities_table.hashes.each do |activity|
        Activity.create(activity)
    end
end