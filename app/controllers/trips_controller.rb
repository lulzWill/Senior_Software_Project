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
        
        if(@trip.main_user_id != @current_user.id)
            flash[:notice] = "You cannot view this trip"
            redirect_to users_homepage_path
        end
        
        @legs = Array.new
        @legNames = Array.new
        
        @trip.legs.each do |leg|
            @legs << leg
            @legNames << leg.name
        end
        @legNames << "Chicago"
        @legNames << "New York"
        @legNames << "New Leg"
    end
    
    def new
        
    end
    
    def create
        if @trip = Trip.create!(main_user_id: @current_user.id, name: params[:trip][:name], description: params[:trip][:description], start_date: params[:start_date], end_date: params[:end_date])
            flash[:notice] = "Trip Added"
            redirect_to trip_path(@trip.id)        
        else
            flash[:notice] = "Something went wrong!"
            redirect_to trips_path
        end
    end
end
