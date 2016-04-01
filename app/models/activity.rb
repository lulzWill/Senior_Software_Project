class Activity < ActiveRecord::Base
    #allow storing objects in data field of Activity table
    #encode as json instead of yaml
    serialize :data, JSON
    
    belongs_to :user
end
