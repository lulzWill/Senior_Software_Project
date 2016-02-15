class LocationsController < ApplicationController
    
    def show
        id = params[:id]
        @location = Location.find(id)
    end
    
end
