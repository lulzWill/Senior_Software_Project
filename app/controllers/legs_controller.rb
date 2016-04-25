class LegsController < ApplicationController
    before_filter :set_current_user
    
    def addVisitToLeg
        @trip = Trip.find(params[:trip_id])
        
        if params[:leg][:name] != ""
            #leg name cannot contain spaces or else the tabs get broken
            leg_name = params[:leg][:name].gsub(" ", "_")
            @leg = @trip.legs.find_or_create_by!(name: leg_name, start_date: params[:leg_start_date], end_date: params[:leg_end_date])
        else
            @leg = @trip.legs.find_by_name(params[:trip][:legs])
        end
        
        @location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])
        #call method to see if this visit would overlap with an already established visit
        if !Visit.overlap?(@current_user.id, @location.id, params[:start_date], params[:end_date])
            #@visit = Visit.create!(user_id: @current_user.id, location_id: @location.id, start_date: params[:start_date], end_date: params[:end_date])
            @visit = @leg.visits.create!(user_id: @current_user.id, location_id: @location.id, start_date: params[:start_date], end_date: params[:end_date])
            #data_hash = {location_name: @location.name, location_id: @location.id}
            #Activity.create!(user_id: @current_user.id, username: @current_user.user_id, profile_pic: @current_user.profile_pic.url, activity_type: "visit", data: data_hash)
            flash[:notice] = "You added #{@location.name} to your trip!"
            redirect_to :back
        else
            flash[:notice] = "We were not able to add #{@location.name} to your trip."
            redirect_to users_homepage_path
        end
    end
    
    def destroy
        @leg = Leg.find(params[:id])
        @trip = @leg.trip
        Leg.find(params[:id]).destroy!
        flash[:notice] = "You deleted #{@leg.name}"
        redirect_to :back
    end

    def update
        @leg = Leg.find(params[:id]) 
        @trip = @leg.trip
        @leg.update(start_date: params[:start_date], end_date: params[:end_date])
        flash[:notice] = "You edited #{@leg.name}"
        redirect_to :back
    end
end
