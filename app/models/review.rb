class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :location
    has_many :review_flags
end
