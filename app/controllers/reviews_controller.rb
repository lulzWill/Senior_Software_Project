class ReviewsController < ApplicationController
    
    def review_params
        params.require(:review).permit(:rating, :comment)
    end
    
    def show
        id = params[:id]
        @review = Review.find(id)
        @location = Location.find(@review.location_id)
    end
    
    def new
    
    end

    def edit
        id = params[:id]
        @review = Review.find(id)
        @location = Location.find(@review.location_id)
    end
    
    def update
        @review = Review.find params[:id]
        @review.update_attributes!(review_params)
        redirect_to review_path(@review)
    end
end
