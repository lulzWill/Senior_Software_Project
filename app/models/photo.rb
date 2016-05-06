class Photo < ActiveRecord::Base
    mount_uploader :data, ProfilePicUploader
    belongs_to :user
    belongs_to :album
    has_many :photo_flags
    
end
