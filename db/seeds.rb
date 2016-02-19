# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Location.create(name: 'University of Iowa', latitude: 10, longitude: 10)
Visit.create(user_id:1, location_id:1, start_date: Date.new(2015,2,3), end_date: Date.new(2015,2,3))
Review.create(user_id:1, location_id:1, visit_id:1, rating:4, comment: 'test comment', flags:0, allowed:true)
Visit.create(user_id:1, location_id:1, start_date: Date.new(2015,2,13), end_date: Date.new(2015,2,20))
Review.create(user_id:1, location_id:1, visit_id:2, rating:1, comment: 'another test', flags:0, allowed:true)
Visit.create(user_id:1, location_id:1, start_date: Date.new(1999,2,13), end_date: Date.new(1999,2,20))
