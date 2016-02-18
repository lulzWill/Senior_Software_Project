class LocationsController < ApplicationController
    
    def show
        @current_user = User.find_by_session_token(cookies[:session_token])
        @location = Location.find(params[:id])
        @reviews = Review.where(location_id: @location.id)
    end
    
end
