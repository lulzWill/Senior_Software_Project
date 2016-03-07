class LocationsController < ApplicationController
    before_filter :set_current_user
    
    def show
        @current_user = User.find_by_session_token(cookies[:session_token])
        @location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
        @reviews = Review.where(location_id: @location.id)
    end

end
