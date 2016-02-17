class LocationsController < ApplicationController
    
    def show
        @location = Location.find(params[:id])
        @reviews = Review.where(location_id: @location.id)
    end
    
    def index
        #need user information
        @current_user = User.find_by_session_token(cookies[:session_token])
        @locations = Locations.where(user_id: @current_user.id) 
    end
    
end
