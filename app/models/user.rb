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
    
    after_create :create_default_conversation
    
    private 
    
    def create_default_conversation
      Conversation.create(sender_id: 1, recipient_id: self.id) unless self.id == 1
    end
end
