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
            allow(@fake_visits).to receive(:order).and_return(@fake_visits)
            allow(Location).to receive(:find_by_id).and_return(@fake_location)
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
            allow(@fake_user).to receive(:trips)
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
    
end
