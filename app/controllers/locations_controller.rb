class LocationsController < ApplicationController
    before_filter :set_current_user
    
    def show
        if params[:from_map] == '1'
            @location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
        else
            @location = Location.find(params[:id])
        end
        
        @reviews = Review.where(location_id: @location.id).limit(5)
        @visits = Visit.where(location_id: @location.id).limit(5)
        @photos = Photo.where(location_id: @location.id).limit(5)
        @review_offset = 5
        @visit_offset = 5
        @photo_offset = 5
    end
    
    def location_reviews
        @location_id = params[:location_id]
        @reviews = Review.order('created_at DESC').where(location_id: @location_id).limit(5).offset(params[:review_offset])
        @review_offset = params[:review_offset].to_i + 5
        respond_to do |format|
            format.js {}
        end
    end
    
    def location_visits
        @location_id = params[:location_id]
        @visits = Visit.order('created_at DESC').where(location_id: @location_id).limit(5).offset(params[:visit_offset])
        @visit_offset = params[:visit_offset].to_i + 5
        respond_to do |format|
            format.js {}
        end
    end
    
    def location_photos
        @location_id = params[:location_id]
        @photos = Photo.order('created_at DESC').where(location_id: @location_id).limit(5).offset(params[:photo_offset])
        @photo_offset = params[:photo_offset].to_i + 5
        respond_to do |format|
            format.js {}
        end
    end

end
