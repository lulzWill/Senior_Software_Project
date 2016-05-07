require 'rails_helper'

RSpec.describe LegsController, type: :controller do
    before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user) 
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:id).and_return(1)
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
    end
    
    describe "addVisitToLeg" do
        it "should add a visit to and existing leg" do
            @fake_trip = double('Trip')
            @fake_leg = double('Leg')
            @fake_location = double('location')
            @fake_visit = double('visit')
            
            allow(Trip).to receive(:find).and_return(@fake_trip)
            allow(@fake_trip).to receive(:legs).and_return(@fake_trip)
            allow(@fake_trip).to receive(:find_by_name).and_return(@fake_leg)
            allow(@fake_leg).to receive(:start_date).and_return(Date.parse('31-12-2010'))
            allow(@fake_leg).to receive(:end_date).and_return(Date.parse('31-12-2012'))
            allow(Location).to receive(:find_or_create_by!).and_return(@fake_location)
            allow(@fake_leg).to receive(:visits).and_return(@fake_visit)
            allow(@fake_visit).to receive(:create!).and_return(@fake_visits)
            allow(@fake_location).to receive(:id).and_return(1)
            allow(@fake_location).to receive(:name).and_return("test")
            
            @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
            post :addVisitToLeg, :leg => {:name => ""}, :trip => {:legs => ""}, :start_date => "31-12-2011", :end_date => "31-12-2011", :latitude => "0", :longitude => "0", :name => "0", :start_time => ""
            
            
            expect(response).to redirect_to(:back)
        end
        
        it "should fail to add a visit to and existing leg if out of date range" do
            @fake_trip = double('Trip')
            @fake_leg = double('Leg')
            @fake_location = double('location')
            @fake_visit = double('visit')
            
            allow(Trip).to receive(:find).and_return(@fake_trip)
            allow(@fake_trip).to receive(:legs).and_return(@fake_trip)
            allow(@fake_trip).to receive(:find_by_name).and_return(@fake_leg)
            allow(@fake_leg).to receive(:start_date).and_return(Date.parse('31-12-2010'))
            allow(@fake_leg).to receive(:end_date).and_return(Date.parse('31-12-2010'))
            allow(Location).to receive(:find_or_create_by!).and_return(@fake_location)
            
            @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
            post :addVisitToLeg, :leg => {:name => ""}, :trip => {:legs => ""}, :start_date => "31-12-2011", :end_date => "31-12-2011", :latitude => "0", :longitude => "0", :name => "0", :start_time => ""
            
            
            expect(response).to redirect_to(:back)
        end
        
          it "should add a visit to a new leg if the leg doesn't exist" do
            @fake_trip = double('Trip')
            @fake_leg = double('Leg')
            @fake_location = double('location')
            @fake_visit = double('visit')
            @fake_legs = double('fake_legs')
            @legs = [double('fakelegs')]
            
            allow(Trip).to receive(:find).and_return(@fake_trip)
            allow(@fake_trip).to receive(:start_date).and_return(Date.parse('27-2-2011'))
            allow(@fake_trip).to receive(:end_date).and_return(Date.parse('27-2-2012'))
            allow(@fake_trip).to receive(:legs).and_return(@legs)
            allow(@leg).to receive(:start_date).and_return(Date.parse('27-2-2013'))
            allow(@leg).to receive(:end_date).and_return(Date.parse('27-2-2013'))
            allow(@fake_trip).to receive(:legs).and_return(@fake_legs)
            allow(@fake_legs).to receive(:each).and_return(@legs.each)
            allow(@fake_legs).to receive(:find_or_create_by!).and_return(@fake_leg)
            allow(@fake_leg).to receive(:start_date).and_return(Date.parse('31-12-2010'))
            allow(@fake_leg).to receive(:end_date).and_return(Date.parse('31-12-2010'))
            allow(Location).to receive(:find_or_create_by!).and_return(@fake_location)
            
            @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
            post :addVisitToLeg, :leg => {:name => "new_leg"}, :trip => {:legs => ""}, :leg_start_date => "31-12-2011", :leg_end_date => "31-12-2011", :start_date => "31-12-2011", :end_date => "31-12-2011", :latitude => "0", :longitude => "0", :name => "0", :start_time => ""
            
            
            expect(response).to redirect_to(:back)
        end
        
        it "should not add a visit to a new leg if the leg overlaps another leg" do
            @fake_trip = double('Trip')
            @fake_leg = double('Leg')
            @fake_location = double('location')
            @fake_visit = double('visit')
            @fake_legs = double('fake_legs')
            @fake_legs2 = double('fake_legs2')
            @fake_leg2 = double('fake_leg2')
            @legs = [@fake_leg2]
            
            allow(Trip).to receive(:find).and_return(@fake_trip)
            allow(@fake_trip).to receive(:start_date).and_return(Date.parse('27-2-2011'))
            allow(@fake_trip).to receive(:end_date).and_return(Date.parse('27-2-2014'))
            allow(@fake_trip).to receive(:legs).and_return(@legs)
            allow(@fake_leg2).to receive(:start_date).and_return(Date.parse('27-2-2013'))
            allow(@fake_leg2).to receive(:end_date).and_return(Date.parse('27-2-2014'))
            #allow(@fake_trip).to receive(:legs).and_return(@fake_legs2)
            #allow(@fake_legs2).to receive(:each).and_return(@legs.each)
            #allow(@fake_legs2).to receive(:find_or_create_by!).and_return(@fake_leg)
            allow(@fake_leg2).to receive(:name).and_return("test")
            allow(@fake_leg).to receive(:start_date).and_return(Date.parse('31-12-2010'))
            allow(@fake_leg).to receive(:end_date).and_return(Date.parse('31-12-2013'))
            allow(Location).to receive(:find_or_create_by!).and_return(@fake_location)
            
            @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
            post :addVisitToLeg, :leg => {:name => "new_leg"}, :trip => {:legs => ""}, :leg_start_date => "20-12-2013", :leg_end_date => "20-12-2013", :start_date => "28-12-2014", :end_date => "28-12-2014", :latitude => "0", :longitude => "0", :name => "0", :start_time => ""
            
            
            expect(response).to redirect_to(:back)
        end
        
        it "should not add a visit to a new leg if the leg is outside of the trip dates" do
            @fake_trip = double('Trip')
            @fake_leg = double('Leg')
            @fake_location = double('location')
            @fake_visit = double('visit')
            @fake_legs = double('fake_legs')
            @legs = [double('fakelegs')]
            
            allow(Trip).to receive(:find).and_return(@fake_trip)
            allow(@fake_trip).to receive(:start_date).and_return(Date.parse('27-2-2011'))
            allow(@fake_trip).to receive(:end_date).and_return(Date.parse('27-2-2012'))
            allow(@fake_trip).to receive(:legs).and_return(@legs)
            allow(@leg).to receive(:start_date).and_return(Date.parse('27-2-2013'))
            allow(@leg).to receive(:end_date).and_return(Date.parse('27-2-2013'))
            allow(@fake_trip).to receive(:legs).and_return(@fake_legs)
            allow(@fake_legs).to receive(:each).and_return(@legs.each)
            allow(@fake_legs).to receive(:find_or_create_by!).and_return(@fake_leg)
            allow(@fake_leg).to receive(:start_date).and_return(Date.parse('31-12-2010'))
            allow(@fake_leg).to receive(:end_date).and_return(Date.parse('31-12-2013'))
            allow(Location).to receive(:find_or_create_by!).and_return(@fake_location)
            
            @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
            post :addVisitToLeg, :leg => {:name => "new_leg"}, :trip => {:legs => ""}, :leg_start_date => "31-12-2011", :leg_end_date => "31-12-2014", :start_date => "28-12-2014", :end_date => "28-12-2014", :latitude => "0", :longitude => "0", :name => "0", :start_time => ""
            
            expect(response).to redirect_to(:back)
        end
    end
    
    describe "POST destory" do
        it "should destroy the leg" do
            @fake_leg = double('fake_leg')
            @fake_trip = double('fake_trip')
            allow(Leg).to receive(:find).and_return(@fake_leg)
            allow(@fake_leg).to receive(:trip).and_return(@fake_trip)
            allow(@fake_leg).to receive(:destroy!).and_return(true)
            allow(@fake_leg).to receive(:name).and_return("test")
            
            @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
            post :destroy, :id => 1
            
            expect(response).to redirect_to(:back)
        end
    end
    
    describe "POST update" do
        it "should update the leg" do
            @fake_leg = double('fake_leg')
            @fake_trip = double('fake_trip')
            allow(Leg).to receive(:find).and_return(@fake_leg)
            allow(@fake_leg).to receive(:trip).and_return(@fake_trip)
            allow(@fake_leg).to receive(:update).and_return(true)
            allow(@fake_leg).to receive(:name).and_return("test")
            
            @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
            post :update, :id => 1, :start_date => "31-2-2014", :end_date => "30-3-2014"
            
            expect(response).to redirect_to(:back)
        end
    end
    
    describe "POST deleteLegVisit" do
        it "should delete the leg" do
            @fake_leg = double('fake_leg')
            @fake_visits = double('fake_visits')
            
            allow(Leg).to receive(:find).and_return(@fake_leg)
            allow(@fake_leg).to receive(:visits).and_return(@fake_visits)
            allow(@fake_visits).to receive(:delete).and_return(true)
            
            post '/legs/deleteLegVisit', :leg_id => 1, :visit_id => 2
            
            expect(response).to render(:nothing)
        end
    end
    
    describe "POST updateLegVisit" do
        it "should update the leg" do
            @fake_leg = double('fake_leg')
            @fake_visits = double('fake_visits')
            
            allow(Leg).to receive(:find).and_return(@fake_leg)
            allow(@fake_leg).to receive(:visits).and_return(@fake_visits)
            allow(@fake_visits).to receive(:find).and_return(@fake_visits)
            allow(@fake_visits).to receive(:update!).and_return(true)
            
            post '/legs/deleteLegVisit', :leg_id => 1, :visit_id => 2, :start_date => "31-2-2011", :visit_time => "31-2-2011"
            
            expect(response).to render(:nothing)
        end
    end
end
