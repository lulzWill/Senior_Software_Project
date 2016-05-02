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
        
        @locations = []
        
        @trip.legs.order("start_date").each do |leg|
            leg.visits.order("start_date", "visit_time").each do |visit|
                @location = Location.find_by_id(visit.location_id)
                @locations.push([@location.latitude, @location.longitude])
             end
            @legs << leg
            @legNames << leg.name
        end

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
    
    def edit
        @trip = Trip.find(params[:id])
    end
    
    def update
        Trip.find(params[:id]).update(name: params[:trip][:name], description: params[:trip][:description], start_date: params[:start_date], end_date: params[:end_date])
        redirect_to trips_path
    end
        
end
