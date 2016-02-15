class ReviewsController < ApplicationController
    
    def show
        id = params[:id]
        @review = Review.find(id)
    end
    
end
