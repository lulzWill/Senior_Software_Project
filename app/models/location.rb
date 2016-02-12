class Location < ActiveRecord::Base
    has_many :reviews
    has_many :visits
    has_many :users, :through => :visits
end
