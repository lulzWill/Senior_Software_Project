class TripsController < ApplicationController
    before_filter :set_current_user
    
    def index
        @trips = @current_user.trips
        @current_trips = @trips.where('start_date < ? AND end_date > ?', DateTime.now,  DateTime.now)
        @future_trips = @trips.where('start_date > ?', DateTime.now)
        @past_trips = @trips.where('end_date < ?', DateTime.now)
    end
    
    def show
        @trip = Trip.find(params[:id])
        
        if(@trip.main_user_id != @current_user.user_id)
            flash[:notice] = "You cannot view this trip"
            redirect_to users_homepage_path
        end
    end
    
end
