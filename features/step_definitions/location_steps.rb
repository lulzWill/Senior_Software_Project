Given /the following locations are in the database:/ do |locations_table|
    locations_table.hashes.each do |location|
        Location.create(location)
    end
end