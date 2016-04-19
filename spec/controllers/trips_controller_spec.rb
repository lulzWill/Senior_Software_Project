require 'rails_helper'

RSpec.describe TripsController, type: :controller do
    before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user) 
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
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
