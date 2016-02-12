class User < ActiveRecord::Base
    has_many :reviews
    has_many :visits
    has_many :locations, :through => :visits
    has_many :friendships
end
