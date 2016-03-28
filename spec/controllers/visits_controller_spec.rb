require 'rails_helper'

RSpec.describe VisitsController, type: :controller do
    before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user) 
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
    end
    describe "GET show" do
        before :each do
            @fake_visit = double('visit')
            allow(Visit).to receive(:find).and_return(@fake_visit)
            allow(@fake_user).to receive(:id).and_return(1)
        end
        it "should get info from model methods if a review is associated" do
            allow(@fake_visit).to receive(:user_id).and_return(1)
            @fake_review = double('review')
            allow(Review).to receive(:find_by).and_return(@fake_review)
            get :show, :id => 1
            expect(assigns(:visit)).to eq(@fake_visit)
            expect(assigns(:review)).to eq(@fake_review)
            expect(assigns(:review_exists)).to eq(true)
        end
        it "should get info from model methods if no review is associated" do
            allow(@fake_visit).to receive(:user_id).and_return(1)
            allow(Review).to receive(:find_by).and_return(nil)
            get :show, :id => 1
            expect(assigns(:visit)).to eq(@fake_visit)
            expect(assigns(:review)).to eq(nil)
            expect(assigns(:review_exists)).to eq(false)
        end
        it "should render the show review template" do
            allow(@fake_visit).to receive(:user_id).and_return(1)
            get :show, :id => 1
            expect(response).to render_template("show") 
        end
        it "should redirect to hompage if user does not own visit" do
            allow(@fake_visit).to receive(:user_id).and_return(0) 
            get :show, :id => 1
            expect(response).to redirect_to users_homepage_path
        end
    end
    
    describe "GET new" do
        before :each do
            get :new, :name => 'town', :latitude => 1, :longitude => 2
        end
        it "should supply info to the view" do
            expect(assigns(:name)).to eq('town')
            expect(assigns(:latitude)).to eq('1')
            expect(assigns(:longitude)).to eq('2')
        end
        it "should render the show review template" do
            expect(response).to render_template("new") 
        end
    end
    
    describe "POST create" do
        before :each do
            @fake_location = double('location')
            @fake_visit = double('visit')
            @fake_pic = double('profile_pic')
            allow(Location).to receive(:find_or_create_by).and_return(@fake_location)
            allow(@fake_user).to receive(:id)
            allow(@fake_user).to receive(:profile_pic).and_return(@fake_pic)
            allow(@fake_pic).to receive(:url)
            allow(@fake_location).to receive(:id)
            allow(Visit).to receive(:create!).and_return(@fake_visit)
        end
        it "should flash 'review added' if no overlap and redirect to visit path" do
            allow(Visit).to receive(:overlap?).and_return(false)
            post :create, :name => "a", :longitude => 10, :latitude => 11, :start_date => "2000-1-1", :end_date => "2000-2-2"
            expect(flash[:notice]).to include("You marked the location")
            expect(response).to redirect_to(visit_path(@fake_visit))
        end
        it "should flash 'already visited' if dates overlap and redirect to homepage" do
            allow(Visit).to receive(:overlap?).and_return(true)
            post :create, :name => "a", :longitude => 10, :latitude => 11, :start_date => "2000-1-1", :end_date => "2000-2-2"
            expect(flash[:notice]).to include("already visited")
            expect(response).to redirect_to("/users/homepage")
        end
    end
    
    describe "GET edit" do
        before :each do
            @fake_visit = double('visit')
            @fake_location = double('location') 
            allow(Visit).to receive(:find).and_return(@fake_visit)
            allow(Location).to receive(:find).and_return(@fake_location)
            allow(@fake_visit).to receive(:location_id)
            allow(@fake_user).to receive(:id).and_return(1)
        end
        it "should supply info to the template" do
            allow(@fake_visit).to receive(:user_id).and_return(1)
            get :edit, :id => 1
            expect(assigns(:visit)).to eq(@fake_visit)
            expect(assigns(:location)).to eq(@fake_location)
        end
        it "should render the edit review template" do
            allow(@fake_visit).to receive(:user_id).and_return(1)
            get :edit, :id => 1
            expect(response).to render_template("edit")
        end
        it "should redirect to hompage if user does not own visit" do
            allow(@fake_visit).to receive(:user_id).and_return(0) 
            get :edit, :id => 1
            expect(response).to redirect_to users_homepage_path
        end
    end
    
    describe "PUT update" do
        before :each do
            @fake_visit = double('visit') 
            allow(Visit).to receive(:find).and_return(@fake_visit)
            allow(@fake_user).to receive(:id)
            allow(@fake_visit).to receive(:location_id)
            allow(@fake_visit).to receive(:update)
        end
        it "should flash 'review added' if no overlap and redirect to visit path" do
            allow(Visit).to receive(:overlap?).and_return(false)
            put :update, :id =>1, :name => 'a', :start_date => "2000-1-1", :end_date => "2000-2-2"
            expect(flash[:notice]).to include("Visit updated")
            expect(response).to redirect_to(visit_path(@fake_visit))
        end
        it "should flash 'already visited' if dates overlap and redirect to homepage" do
            allow(Visit).to receive(:overlap?).and_return(true)
            put :update, :id =>1, :name => 'a', :start_date => "2000-1-1", :end_date => "2000-2-2"
            expect(flash[:notice]).to include("already visited")
            expect(response).to redirect_to("/users/homepage")
        end
    end
    
    describe "GET index" do
        it "should supply info about visits to template" do
            @fake_visit = double('visit')
            allow(@fake_user).to receive(:id)
            allow(Visit).to receive(:where).and_return(@fake_visit)
            get :index
            expect(assigns(:visits)).to eq(@fake_visit)
            expect(assigns(:current_user)).to eq(@fake_user)
            expect(response).to render_template("index")
        end
    end
    
end
