class LegsController < ApplicationController
    before_filter :set_current_user
    
    def addVisitToLeg
        @trip = Trip.find(params[:trip_id])
        
        if params[:leg][:name] != ""
            #leg name cannot contain spaces or else the tabs get broken
            if(@trip.start_date <= DateTime.parse(params[:leg_start_date]) && @trip.end_date >= DateTime.parse(params[:leg_end_date]) && DateTime.parse(params[:leg_start_date]) <= DateTime.parse(params[:leg_end_date]))
                @trip.legs.each do |leg|
                    if((leg.start_date <= DateTime.parse(params[:leg_start_date]) && leg.end_date >= DateTime.parse(params[:leg_end_date])) || (leg.start_date >= DateTime.parse(params[:leg_start_date]) && leg.end_date >= DateTime.parse(params[:leg_end_date])) || (leg.start_date <= DateTime.parse(params[:leg_start_date]) && leg.end_date <= DateTime.parse(params[:leg_end_date])))
                        flash[:notice] = "Could not add leg: Dates overlap another existing leg"
                        redirect_to :back and return
                    end
                end
                leg_name = params[:leg][:name].gsub(" ", "_")
                @leg = @trip.legs.find_or_create_by!(name: leg_name, start_date: params[:leg_start_date], end_date: params[:leg_end_date])
            else
                flash[:notice] = "Could not add leg: Dates are outside of trip bounds."
                redirect_to :back
            end
        else
            @leg = @trip.legs.find_by_name(params[:trip][:legs])
        end
        
        @location = Location.find_or_create_by!(name: params[:name], latitude: params[:latitude], longitude: params[:longitude])

        #@visit = Visit.create!(user_id: @current_user.id, location_id: @location.id, start_date: params[:start_date], end_date: params[:end_date])
        @visit = @leg.visits.create!(user_id: @current_user.id, location_id: @location.id, start_date: params[:start_date], visit_time: params[:visit_time])
        #data_hash = {location_name: @location.name, location_id: @location.id}
        #Activity.create!(user_id: @current_user.id, username: @current_user.user_id, profile_pic: @current_user.profile_pic.url, activity_type: "visit", data: data_hash)
        flash[:notice] = "You added #{@location.name} to your trip!"
        redirect_to :back
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
