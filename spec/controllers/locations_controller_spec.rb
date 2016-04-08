require 'rails_helper'
require 'spec_helper'

RSpec.describe LocationsController, type: :controller do
    before :each do
        @fake_user = double('user')
        @fake_review = double('review')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user)
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
        @fake_location_results = double('location1')
        allow(@fake_location_results).to receive(:id)
        allow(Review).to receive(:where).and_return(@fake_review)
    end
    describe "GET show from map" do
        before :each do
            allow(Location).to receive(:find_or_create_by!).and_return(@fake_location_results)
            allow(@fake_review).to receive(:limit).and_return(@fake_review)
        end
        it "should collect the information for that location" do
            get :show, {:id => 1, :from_map => 1}
            expect(assigns(:location)).to eq(@fake_location_results)
            expect(assigns(:reviews)).to eq(@fake_review)
        end
        it "should render the show location view" do
            get :show, {:id => 1, :from_map => 1}
            expect(response).to render_template(:show) 
        end
    end
    
    describe "GET show from link" do
        before :each do
            allow(Location).to receive(:find).and_return(@fake_location_results)
            allow(@fake_review).to receive(:limit).and_return(@fake_review)
        end
        it "should collect the information for that location" do
            get :show, {:id => 1}
            
        end
        it "should render the show location view" do
            get :show, {:id => 1}
            expect(response).to render_template(:show) 
        end
    end
    
    describe 'POST location newsfeed methods' do
      before :each do
        @fake_current_user = double('current_user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_current_user)
        allow(@fake_current_user).to receive(:user_id).and_return("testid")
        allow(@fake_current_user).to receive(:inverse_friends).and_return(Array.new)
        @fake_user = double('user')
        allow(User).to receive(:find).and_return(@fake_user)
        allow(@fake_user).to receive(:id)
      end
      it "should get the next set of reviews to display in the newsfeed" do
        allow(Review).to receive(:where)
        post :location_reviews, :format => 'js', :location_id => '1', :review_offset => '1'
        expect(assigns(:reviews)).to eq([])
        expect(response).to render_template('location_reviews')
      end
      it "should get the next set of visits to display in the newsfeed" do
        allow(Visit).to receive(:where)
        post :location_visits, :format => 'js', :location_id => '1', :visit_offset => '1'
        expect(assigns(:visits)).to eq([])
        expect(response).to render_template('location_visits')
      end
      it "should get the next set of photos to display in the newsfeed" do
        allow(Photo).to receive(:where)
        post :location_photos, :format => 'js', :location_id => '1', :photo_offset => '1'
        expect(assigns(:photos)).to eq([])
        expect(response).to render_template('location_photos')
      end
    end
    
end
