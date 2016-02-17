class User < ActiveRecord::Base
    has_secure_password
    mount_uploader :profile_pic, ProfilePicUploader
    validates :email, :user_id, :password, presence: true
    validates :user_id, uniqueness: true
    validates :email, uniqueness: true
end
