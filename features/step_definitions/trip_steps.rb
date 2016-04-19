Given /the following trips are in the database:/ do |trips_table|
    trips_table.hashes.each do |trip|
        Trip.create(trip)
    end
end