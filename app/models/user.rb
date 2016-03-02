class User < ActiveRecord::Base
    has_secure_password
    mount_uploader :profile_pic, ProfilePicUploader
    validates :email, :user_id, :password_digest, presence: true
    validates :user_id, uniqueness: true
    validates :email, uniqueness: true

    has_many :reviews
    has_many :visits
    has_many :locations, :through => :visits
    has_many :friendships
    has_many :photos
    has_many :albums
    has_many :conversations, :foreign_key => :sender_id
end
