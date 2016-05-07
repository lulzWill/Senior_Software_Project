require 'rails_helper'

RSpec.describe TripsController, type: :controller do
    before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user) 
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:id).and_return(1)
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
    end
    describe "GET show" do
        it "show displays the show trip page correctly" do
            @fake_trip = double('trip')
            @fake_legs = double('legs')
            @fake_leg = double('leg')
    
            @fake_visit_1 = double('visit1')
            @fake_visit_2 = double('visit2')
            @fake_visits = double('visits')
            @fake_array = [@fake_visit_1,@fake_visit_2]
            @fake_leg_array = [@fake_leg]
            @fake_location = double('location')        
            allow(Trip).to receive(:find).and_return(@fake_trip)
            allow(@fake_trip).to receive(:main_user_id).and_return(1)
            allow(@fake_trip).to receive(:legs).and_return(@fake_legs)
            allow(@fake_legs).to receive(:order).and_return(@fake_leg_array)
            allow(@fake_leg).to receive(:visits).and_return(@fake_visits)
            allow(@fake_visits).to receive(:order).and_return(@fake_array)
            allow(Location).to receive(:find_by_id).and_return(@fake_location)
            allow(@fake_location).to receive(:latitude).and_return(1)
            allow(@fake_location).to receive(:longitude).and_return(1)
            allow(@fake_visit_1).to receive(:location_id).and_return("test")
            allow(@fake_visit_2).to receive(:location_id).and_return("test")
            allow(@fake_leg).to receive(:name).and_return("test_name")
            allow(@fake_visits).to receive(:each).and_return(@fake_array.each)
            get :show, :id => '1'

            expect(response).to render_template("show")
        end
        it "show redirects properly if not current user" do
            @fake_trip = double('trip')
            @fake_legs = double('legs')
            @fake_leg = double('leg')
    
            @fake_visit_1 = double('visit1')
            @fake_visit_2 = double('visit2')
            @fake_visits = double('visits')
            @fake_array = [@fake_visit_1,@fake_visit_2]
            @fake_leg_array = [@fake_leg]
            @fake_location = double('location') 
            
            allow(Trip).to receive(:find).and_return(@fake_trip)
            allow(@fake_trip).to receive(:main_user_id).and_return(2)
            allow(@fake_trip).to receive(:legs).and_return(@fake_legs)
            allow(@fake_legs).to receive(:order).and_return(@fake_leg_array)
            allow(@fake_leg).to receive(:visits).and_return(@fake_visits)
            allow(@fake_visits).to receive(:order).and_return(@fake_visits)
            allow(Location).to receive(:find_by_id).and_return(@fake_location)
            allow(@fake_visit_1).to receive(:location_id).and_return("test")
            allow(@fake_visit_2).to receive(:location_id).and_return("test")
            allow(@fake_leg).to receive(:name).and_return("test_name")
            allow(@fake_visits).to receive(:each).and_return(@fake_array.each)
            get :show, :id => '1'

            expect(response).to redirect_to(users_homepage_path)
        end
    end
    
    describe "GET index" do
        it "should supply info about trips to template" do
            @fake_trips = double('trips')
            @fake_current_trip = double('current_trip')
            @fake_future_trip = double('future_trip')
            @fake_past_trip = double('past_trip')
            allow(@fake_user).to receive(:trips).and_return(@fake_trips)
            allow(@fake_trips).to receive(:where).with('start_date < ? AND end_date > ?', DateTime.now,  DateTime.now).and_return(@fake_current_trip)
            allow(@fake_trips).to receive(:where).with('start_date > ?', DateTime.now).and_return(@fake_future_trip)
            allow(@fake_trips).to receive(:where).with('end_date < ?', DateTime.now).and_return(@fake_past_trip)
            get :index
            expect(assigns(:current_trips)).to eq(@fake_current_trip)
            expect(assigns(:future_trips)).to eq(@fake_future_trip)
            expect(assigns(:past_trips)).to eq(@fake_past_trip)
            expect(response).to render_template("index")
        end
    end
    
    describe "POST create" do
        it "should redirect to the trip page after creating a trip" do
            @fake_trip = double('trip')
            allow(Trip).to receive(:create!).and_return(@fake_trip)
            allow(@fake_trip).to receive(:id).and_return(1)
            
            post :create, :trip => {:name => "test", :description => "test"}, :start_date => "", :end_date => ""
            
            expect(response).to redirect_to(trip_path(1))
        end
        it "should redirect to the trips path is the create fails" do
            @fake_trip = double('trip')
            allow(Trip).to receive(:create!).and_return(false)

            post :create, :trip => {:name => "test", :description => "test"}, :start_date => "", :end_date => ""
            
            expect(response).to redirect_to(trips_path)
        end
    end
    
    describe "GET edit" do
        it "should assign the trip to a variable that the view can see" do
            @fake_trip = double('trip')
            allow(Trip).to receive(:find).and_return(@fake_trip)

            get :edit, :id => "1"
            
            expect(response).to render_template("edit")
            expect(assigns(:trip)).to eq(@fake_trip)
        end
    end
    
     describe "post update" do
        it "should assign the trip to a variable that the view can see" do
            @fake_trip = double('trip')
            allow(Trip).to receive(:find).and_return(@fake_trip)
            allow(@fake_trip).to receive(:update).and_return(@fake_trip)
            post :update, :id => "1", :trip => {:name => "test", :description => "test"}, :start_date => "", :end_date => ""
            
            expect(response).to redirect_to(trips_path)
        end
    end
end
