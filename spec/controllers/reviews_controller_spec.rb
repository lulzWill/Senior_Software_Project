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
        it "created from visit page: should provide data to template" do
            @fake_visit = double('visit')
            @fake_location = double('location')
            allow(Visit).to receive(:find).and_return(@fake_visit)
            allow(Location).to receive(:find).and_return(@fake_location)
            get :new, :visit_id => 1
            expect(assigns(:visit)).to eq(@fake_visit)
            expect(assigns(:location)).to eq(@fake_location)
        end
        before :each do
            get :new, :id => 1, :name => "a", :longitude => 10, :latitude => 11
        end
        it "created from map: should provide data to template" do
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
            @fake_review = double('review')
            @fake_pic = double('profile_pic')
            allow(Location).to receive(:find_or_create_by).and_return(@fake_location)
            allow(@fake_location).to receive(:id)
            allow(@fake_location).to receive(:name)
            allow(Visit).to receive(:create!).and_return(@fake_visit)
            allow(@fake_visit).to receive(:id)
            allow(Review).to receive(:create!).and_return(@fake_review)
            allow(@fake_review).to receive(:id)
            allow(@fake_review).to receive(:rating)
            allow(@fake_user).to receive(:id)
            allow(@fake_location).to receive(:id)
            allow(@fake_user).to receive(:profile_pic).and_return(@fake_pic)
            allow(@fake_pic).to receive(:url)
        end
        context "review added from map" do
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
        end
        context "added from visit page" do
            it "should flash 'review added'" do
                allow(Location).to receive(:find).and_return(@fake_location)
                allow(Visit).to receive(:find).and_return(@fake_visit)
                post :create, :review => {:user_id => 1, :location_id => 1, :rating => 1, :comment => "fine"}, 
                                  :start_date => "2000-1-1", :visit_id => 1
                expect(flash[:notice]).to include("Review added")
            end
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
            allow(@fake_user).to receive(:id).and_return(1)
        end
        it "should supply info to the template" do
            allow(@fake_review).to receive(:user_id).and_return(1)
            get :edit, :id => 1
            expect(assigns(:review)).to eq(@fake_review)
            expect(assigns(:location)).to eq(@fake_location)
        end
        it "should render the edit review template" do
            allow(@fake_review).to receive(:user_id).and_return(1)
            get :edit, :id => 1
            expect(response).to render_template("edit")
        end
        it "should redirect to hompage if user does not own review" do
            allow(@fake_review).to receive(:user_id).and_return(0) 
            get :edit, :id => 1
            expect(response).to redirect_to users_homepage_path
        end
    end
    
    describe "PUT update" do
        before :each do
            @fake_review = double('review') 
            allow(Review).to receive(:find).and_return(@fake_review)
            allow(@fake_review).to receive(:update_attributes!)
            allow(@fake_review).to receive(:visit_id).and_return(1)
            put :update, :id => 1, :review => {:user_id => 1, :location_id => 1, :rating => 1, :comment => "fine"}
        end
        it "should flash 'Review updated'" do
            expect(flash[:notice]).to include("Review updated")
        end
        it "should redirect to the homepage" do
            expect(response).to redirect_to(visit_path(1))
        end
    end
    
    describe "GET index" do
        it "should supply info about reviews to template" do
            @fake_review = double('review')
            allow(@fake_user).to receive(:id)
            allow(Review).to receive(:where).and_return(@fake_review)
            get :index
            expect(assigns(:reviews)).to eq(@fake_review)
            expect(assigns(:current_user)).to eq(@fake_user)
            expect(response).to render_template("index")
        end
    end

    describe "DESTROY destroy" do
        it "should delete reviews when selected" do
            @fake_review = double('review')
            allow(Review).to receive(:find).and_return(@fake_review)
            allow(@fake_review).to receive(:destroy!)
            delete :destroy, :id => 1
        end
        it 'should redirect to homepage' do
            expect(response).to redirect_to('homepage')
        end
    end

end
