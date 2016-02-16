class ReviewsController < ApplicationController
    
    def review_params
        params.require(:review).permit(:user_id, :location_id, :rating, :comment, :date)
    end
    
    def show
        @review = Review.find(params[:id])
        @location = Location.find(@review.location_id)
    end
    
    def new
        #@user = User.find(params[:user_id])
        @location = Location.find(params[:location_id])
        
        #also create visit table entry if it does not yet exist
        #Visit.create!(:user_id => @user.id, :location_id => @location.id, :start_date => params[:date])
    end
    
    def create
        
    end

    def edit
        @review = Review.find(params[:id])
        @location = Location.find(@review.location_id)
    end
    
    def update
        #update review table entry
        @review = Review.find params[:id]
        @review.update_attributes!(review_params)
        #update date in corresponding visit table entry
        @visit = Visit.find_by(user_id: @review.user_id, location_id: @review.location_id)
        @visit.update(:start_date)
        redirect_to review_path(@review)
    end
end
