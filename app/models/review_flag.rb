class ReviewFlag < ActiveRecord::Base
    belongs_to :users
    belongs_to :reviews
end
