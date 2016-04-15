# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(user_id: 'chuck', password: 'chuck1', email: 'a@b.com')
User.create(user_id: 'chuck1', password: 'chuck1', email: 'b@a.com')
User.create(user_id: 'jarred', password: 'jarred1', email: 'f@b.com')
#Friendship.create(user1_id:1,friend_id:2)
#Friendship.create(user2_id:2,friend_id:1)
User.create(user_id: 'will', password: 'will1', email: 'c@c.com')
User.create(user_id: 'will2', password: 'will1', email: 'c@c.com')
Location.create(name: 'The University of Iowa', latitude: 41.6626963, longitude: -91.55489979999999)
Visit.create(user_id:1, location_id:1, start_date: Date.new(2000,2,3), end_date: Date.new(2000,2,3))
Review.create(user_id:1, location_id:1, visit_id:1, rating:4, comment: 'test comment', flags:0, allowed:true)
Visit.create(user_id:1, location_id:1, start_date: Date.new(2005,2,13), end_date: Date.new(2005,2,20))
Review.create(user_id:1, location_id:1, visit_id:2, rating:1, comment: 'another test', flags:0, allowed:true)
Visit.create(user_id:1, location_id:1, start_date: Date.new(1999,2,13), end_date: Date.new(1999,2,20))
Conversation.create(sender_id: 1, recipient_id: 2)
User.create(user_id: 'chuck2', password: 'chuck1', email: 'b@b.com')
User.create(user_id: 'chuck3', password: 'chuck1', email: 'c@b.com')
User.create(user_id: 'chuck4', password: 'chuck1', email: 'd@b.com')
User.create(user_id: 'chuck5', password: 'chuck1', email: 'e@b.com')
