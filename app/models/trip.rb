class Trip < ActiveRecord::Base
    
    has_many :legs
    belongs_to :user, :foreign_key => :main_user_id
    #has_many :users
    
end
