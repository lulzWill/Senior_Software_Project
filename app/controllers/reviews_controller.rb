class ReviewsController < ApplicationController
    
    def show
        id = params[:id]
        @review = Review.find(id)
        @location = Location.find(@review.location_id)
    end
    
end
