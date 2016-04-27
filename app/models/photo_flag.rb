class PhotoFlag < ActiveRecord::Base
    belongs_to :users
    belongs_to :photos
end
