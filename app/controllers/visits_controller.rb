class VisitsController < ApplicationController
    before_filter :set_current_user
    #def location_params
     #   params.require(:location).permit(:name, :latitude, :longitude)
    #end

    def new
        #@location_hash = params[:location]
        @name = params[:name]
        @longitude = params[:longitude]
        @latitude = params[:latitude]
    end

    def create
        @current_user = User.find_by_session_token(cookies[:session_token])
        #create entry in location table if it doesn't exist
        @location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
        #call method to see if this visit would overlap with an already established visit
        if !Visit.overlap?(@current_user.id, @location.id, params[:start_date], params[:end_date])
            #@visit = Visit.create!(user_id: @current_user.id, location_id: @location.id, start_date: params[:start_date], end_date: params[:end_date])
            @visit = Visit.create!(user_id: @current_user.id, location_id: @location.id, start_date: params[:start_date])
            data_hash = {location_name: @location.name, location_id: @location.id}
            Activity.create!(user_id: @current_user.id, username: @current_user.user_id, profile_pic: @current_user.profile_pic.url, activity_type: "visit", data: data_hash)
            flash[:notice] = "You marked the location!"
            redirect_to visit_path(@visit)
        else
            flash[:notice] = "You've already visited " + params[:name].to_s + " on those dates."
            redirect_to users_homepage_path
        end
    end

    def edit
        @visit = Visit.find(params[:id])
        @location = Location.find(@visit.location_id)
        if @current_user.id != @visit.user_id
            redirect_to users_homepage_path
        end
    end

    def update
        @visit = Visit.find(params[:id])
        if !Visit.overlap?(@current_user.id, @visit.location_id, params[:start_date], params[:end_date])
            #@visit.update(start_date: params[:start_date], end_date: params[:end_date])
            @visit.update(start_date: params[:start_date])
            flash[:notice] = "Visit updated!"
            redirect_to visit_path(@visit)
        else
            flash[:notice] = "You've already visited " + params[:name].to_s + " on that date."
            redirect_to users_homepage_path
        end
    end

    def index
        @visits = Visit.where(user_id: @current_user.id)
    end

    def show
        @visit = Visit.find(params[:id])
        if @current_user.id != @visit.user_id
            redirect_to users_homepage_path
        end
        @review = Review.find_by(visit_id: params[:id])
        @review_exists = true
        if @review == nil
            @review_exists = false
        end
    end

end
