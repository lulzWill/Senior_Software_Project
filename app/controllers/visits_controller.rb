class VisitsController < ApplicationController
    def location_params
        params.require(:location).permit(:name, :latitude, :longitude)
    end
    
    def new
    
    end
    
    def create
        @current_user = User.find_by_session_token(cookies[:session_token])
        #create entry in location table if it doesn't exist
        @location = Location.find_or_create_by(location_params)
        #ignoring start/end dates for now
        Visit.create!(user_id: @current_user.id, location_id: @location.id)
    end
    
    def edit
        @visit = Visit.find(params[:id])
        @location = Location.find(@visit.location_id)
    end
    
    def update
        #update date in corresponding visit table entry
        @visit = Visit.find(params[:id])
        @visit.update(start_date: params[:start_date], end_date: params[:end_date])
        redirect_to visit_path(@visit)
    end
    
    def index
        @current_user = User.find_by_session_token(cookies[:session_token])
        if @current_user == nil
            redirect_to new_user_path
        else
            @visits = Visit.where(user_id: @current_user.id)
        end
    end
    
    def show
        @visit = Visit.find(params[:id])
        @review = Review.find_by(visit_id: params[:id])
    end
    
end
