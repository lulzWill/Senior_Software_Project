class VisitsController < ApplicationController
    def location_params
        params.require(:location).permit(:name, :latitude, :longitude)
    end
    
    def new
        @name = params[:name]
        @longitude = params[:longitude]
        @latitude = params[:latitude]
    end
    
    def create
        @current_user = User.find_by_session_token(cookies[:session_token])
        #create entry in location table if it doesn't exist
        @location = Location.find_or_create_by(location_params)
        #ignoring start/end dates for now
        Visit.create!(user_id: @current_user.id, location_id: @location.id)
    end
end
