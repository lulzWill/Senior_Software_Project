class TripsController < ApplicationController
    before_filter :set_current_user
    
    
    def index
        @trips = @current_user.trips
        @current_trips = @trips.where('start_date < ? AND end_date > ?', DateTime.now,  DateTime.now)
        @future_trips = @trips.where('start_date > ?', DateTime.now)
        @past_trips = @trips.where('end_date < ?', DateTime.now)
    end
    
end
