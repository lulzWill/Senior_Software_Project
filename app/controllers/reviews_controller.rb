class ReviewsController < ApplicationController

    def review_params
        params.require(:review).permit(:user_id, :location_id, :rating, :comment)
    end

    def location_params
        params.require(:location).permit(:name, :latitude, :longitude)
    end

    def visit_params
        params.require(:visit).permit(:user_id, :location_id)
    end

    def show
        @current_user = User.find_by_session_token(cookies[:session_token])
        @review = Review.find(params[:id])
        @location = Location.find(@review.location_id)
        #find out why this returns nil
        @user = User.find(@review.user_id)
    end

    def new
        @current_user = User.find_by_session_token(cookies[:session_token])
        @name = params[:name]
        @longitude = params[:longitude]
        @latitude = params[:latitude]
        #create location table entry if it does not yet exist
        #@location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
        #also create visit table entry if it does not yet exist
        #@visits = Visit.where(:user_id => @current_user.id, :location_id => @location.id)
    end

    def create
        location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
        if !Visit.overlap?(params[:user_id], location.id, params[:start_date], params[:end_date])
            visit = Visit.create!(user_id: params[:user_id], location_id: location.id, start_date: params[:start_date], end_date: params[:end_date])
            Review.create!(user_id: params[:user_id], visit_id: visit.id, location_id: location.id, rating: params[:review][:rating], comment: params[:review][:comment], flags:0, allowed:true)
            flash[:notice] = "Review added!"
        else
            flash[:notice] = "You've already visited " + params[:name] + " on those dates."
        end
        redirect_to users_homepage_path
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
        #@visit = Visit.find_by(user_id: @review.user_id, location_id: @review.location_id)
        #@visit.update(:start_date => params[:date])
        flash[:notice] = "Review updated!"
        redirect_to review_path(@review)
    end
end
