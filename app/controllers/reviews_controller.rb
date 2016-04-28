class ReviewsController < ApplicationController
    
    before_filter :set_current_user
    
    def review_params
        params.require(:review).permit(:user_id, :location_id, :rating, :comment)
    end

    def show
        @current_user = User.find_by_session_token(cookies[:session_token])
        @review = Review.find(params[:id])
        @location = Location.find(@review.location_id)
        #get user info of reviewer
        @user = User.find(@review.user_id)
    end
    
    def index
        @reviews = Review.where(user_id: @current_user.id)
    end

    def new
        if params[:visit_id] == nil
            @name = params[:name]
            @longitude = params[:longitude]
            @latitude = params[:latitude]
        else
            @visit = Visit.find(params[:visit_id])
            @location = Location.find(params[:location_id])
        end
    end

    def create
        if params[:visit_id] == nil
            location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
            if !Visit.overlap?(params[:user_id], location.id, params[:start_date], params[:end_date])
                #visit = Visit.create!(user_id: params[:user_id], location_id: location.id, start_date: params[:start_date], end_date: params[:end_date])
                visit = Visit.create!(user_id: params[:user_id], location_id: location.id, start_date: params[:start_date])
                review = Review.create!(user_id: params[:user_id], visit_id: visit.id, location_id: location.id, rating: params[:review][:rating], comment: params[:review][:comment], flagged: false, allowed:true)
                data_hash = {review_id: review.id, rating: review.rating, location_id: location.id, location_name: location.name}
                Activity.create!(user_id: @current_user.id, username: @current_user.user_id, profile_pic: @current_user.profile_pic.url, activity_type: "review", data: data_hash)
                flash[:notice] = "Review added!"
            else
                flash[:notice] = "You've already visited " + params[:name].to_s + " on that date."
            end
        else
            location = Location.find(params[:location_id])
            visit = Visit.find(params[:visit_id])
            review = Review.create!(user_id: params[:user_id], visit_id: visit.id, location_id: location.id, rating: params[:review][:rating], comment: params[:review][:comment], flagged: false, allowed:true)
            data_hash = {review_id: review.id, rating: review.rating, location_id: location.id, location_name: location.name}
            Activity.create!(user_id: @current_user.id, username: @current_user.user_id, profile_pic: @current_user.profile_pic.url, activity_type: "review", data: data_hash)
            flash[:notice] = "Review added!"
        end
        redirect_to users_homepage_path
    end

    def edit
        @review = Review.find(params[:id])
        @location = Location.find(@review.location_id)
        if @current_user.id != @review.user_id
            redirect_to users_homepage_path
        end
    end

    def update
        #update review table entry
        @review = Review.find params[:id]
        @review.update_attributes!(review_params)
        flash[:notice] = "Review updated!"
        redirect_to visit_path(@review.visit_id)
    end
    
    def flag_review
        ReviewFlag.create!(user_id: @current_user.id, review_id: params[:review_id])
        render :nothing => true
    end
    
end
