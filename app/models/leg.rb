class Leg < ActiveRecord::Base
    
    belongs_to :trip
    has_many :visits
    
end
