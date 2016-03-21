class LocationsController < ApplicationController
    before_filter :set_current_user
    
    def show
        if params[:from_map] == '1'
            @location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
        else
            @location = Location.find(params[:id])
        end
        @reviews = Review.where(location_id: @location.id)
    end

end
