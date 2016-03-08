require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
    before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user)
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
    end
    describe "GET show" do
        before :each do
            @fake_review = double('review')
            @fake_location = double('location')
            allow(Review).to receive(:find).and_return(@fake_review)
            allow(Location).to receive(:find).and_return(@fake_location)
            allow(User).to receive(:find).and_return(@fake_user)
            allow(@fake_review).to receive(:location_id)
            allow(@fake_review).to receive(:user_id)
            get :show, :id => 1
        end
        it "should get info from model methods" do
            expect(assigns(:review)).to eq(@fake_review)
            expect(assigns(:location)).to eq(@fake_location)
            expect(assigns(:user)).to eq(@fake_user)
        end
        it "should render the show review template" do
            expect(response).to render_template("show") 
        end
    end
    
    describe "GET new" do
        before :each do
            get :new, :id => 1, :name => "a", :longitude => 10, :latitude => 11
        end
        it "should provide data to template" do
            expect(assigns(:name)).to eq("a")
            expect(assigns(:longitude)).to eq("10")
            expect(assigns(:latitude)).to eq("11")
        end
        it "should render the new review template" do
            expect(response).to render_template("new")
        end
    end
    
    describe "POST create" do
        before :each do
            @fake_location = double('location')
            @fake_visit = double('visit')
            allow(Location).to receive(:find_or_create_by).and_return(@fake_location)
            allow(@fake_location).to receive(:id)
            allow(Visit).to receive(:create!).and_return(@fake_visit)
            allow(@fake_visit).to receive(:id)
            allow(Review).to receive(:create!)
            
        end
        it "should flash 'review added' if no overlap" do
            allow(Visit).to receive(:overlap?).and_return(false)
            post :create, :review => {:user_id => 1, :location_id => 1, :rating => 1, :comment => "fine"}, 
                          :name => "a", :longitude => 10, :latitude => 11, :start_date => "2000-1-1", 
                          :end_date => "2000-2-2"
            expect(flash[:notice]).to include("Review added")
        end
        it "should flash 'already visited' if dates overlap" do
            allow(Visit).to receive(:overlap?).and_return(true)
            post :create, :review => {:user_id => 1, :location_id => 1, :rating => 1, :comment => "fine"}, 
                          :name => "a", :longitude => 10, :latitude => 11, :start_date => "2000-1-1", 
                          :end_date => "2000-2-2"
            expect(flash[:notice]).to include("already visited")
        end
        it "should redirect to homepage" do
            post :create, :review => {:user_id => 1, :location_id => 1, :rating => 1, :comment => "fine"}, 
                          :name => "a", :longitude => 10, :latitude => 11, :start_date => "2000-1-1", 
                          :end_date => "2000-2-2"
            expect(response).to redirect_to("/users/homepage")
        end
    end
    
    describe "GET edit" do
        before :each do
            @fake_review = double('review')
            @fake_location = double('location') 
            allow(Review).to receive(:find).and_return(@fake_review)
            allow(Location).to receive(:find).and_return(@fake_location)
            allow(@fake_review).to receive(:location_id)
            get :edit, :id => 1
        end
        it "should supply info to the template" do
            expect(assigns(:review)).to eq(@fake_review)
            expect(assigns(:location)).to eq(@fake_location)
        end
        it "should render the edit review template" do
            expect(response).to render_template("edit")
        end
    end
    
    describe "PUT update" do
        before :each do
            @fake_review = double('review') 
            allow(Review).to receive(:find).and_return(@fake_review)
            allow(@fake_review).to receive(:update_attributes!)
            put :update, :id => 1, :review => {:user_id => 1, :location_id => 1, :rating => 1, :comment => "fine"}
        end
        it "should flash 'Review updated'" do
            expect(flash[:notice]).to include("Review updated")
        end
        it "should redirect to the homepage" do
            expect(response).to redirect_to(review_path(@fake_review))
        end
    end

end
