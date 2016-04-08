require 'rails_helper'
require 'spec_helper'

describe UsersController do
    describe 'creating a User' do
        it 'should call the model method to make a new user and the method model to save a new user and redirect to login when successful' do
          expect(User).to receive(:find_by_user_id).with('fakeid').and_return(false)
          
          fakeUser = double("user");
          
          expect(User).to receive(:new).and_return(fakeUser)
          expect(fakeUser).to receive(:save).and_return(true)
          
          post :create, {:user => {:email => "fake@fake.com", :user_id => "fakeid", :password => "fakepass", :first_name => "first", :last_name => "last", :gender => "Male"}}
          expect(assigns(:user)).to eq fakeUser
          expect(response).to redirect_to(new_user_path)
          expect(flash[:notice]).to eq("Welcome first! You have successfully signed up as a User of Backpack Traveler!")
        end
        
        it 'should redirect to sign up page if there is an error creating the user' do
          expect(User).to receive(:find_by_user_id).with('fakeid').and_return(false)
    
          fakeUser = double("user");
          
          expect(User).to receive(:new).and_return(fakeUser)
          expect(fakeUser).to receive(:save).and_return(false)
          
          post :create, {:user => {:email => "fake@fake.com", :user_id => "fakeid", :password => "fakepass", :first_name => "first", :last_name => "last", :gender => "Male"}}
          expect(assigns(:user)).to eq fakeUser
          expect(response).to redirect_to(new_user_path)
          expect(flash[:notice]).to eq("Sorry, something went wrong. Please try again")
        end
        
        it 'should redirect to sign up page if the user already exists in the database' do
          expect(User).to receive(:find_by_user_id).with('fakeid').and_return(true)
          
          post :create, {:user => {:email => "fake@fake.com", :user_id => "fakeid", :password => "fakepass", :first_name => "first", :last_name => "last", :gender => "Male"}}
          expect(response).to redirect_to(new_user_path)
          expect(flash[:notice]).to eq("Sorry, but that user id is already taken")
        end
    end
    
    describe 'searching for users: ' do
      before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user)
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
      end
      it 'autocomplete should return user info' do
        get :user_search, {:format => :json, :term => 'abc'}
        expect(response).to be_success
      end
      it "should supply results to template" do
        @fake_user_result = double(['user_result'])
        allow(User).to receive(:where).and_return(@fake_user_result)
        get :user_search, {:link => {:origin_id => 1}}
        expect(assigns(:users)).to eq(@fake_user_result)
        expect(response).to render_template("user_search")
      end
    end
    
    describe 'searching for yelp results ' do
      before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user)
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
      end
      it "should supply results to template" do
        get :_yelp_results,:term => "hotel",:latitude => "41.669088",:longitude => "-91.563481",:address => "87 2nd St, Coralville, IA 52241",:name =>"heartland inn"
        expect(assigns(:results).businesses[0].name).to eq("Heartland Inn")
        expect(assigns(:street)).to eq("87 2nd St")
        expect(response).to render_template(:partial => '_yelp_results')
      end
    end
    
    describe 'displaying user data on map' do
      before :each do
        @fake_user = double('user')
        @fake_location = double('location')
        @fake_locations = double('location')
        @fake_visit = double('visit')
        @fake_visits = [@fake_visit]
        @fake_review = double('review')
        
        allow(User).to receive(:find_by_session_token).and_return(@fake_user)
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:id)
        @fake_user2 = double('user2')
        allow(@fake_user).to receive(:inverse_friends).and_return([@fake_user2])
        
        allow(@fake_user).to receive(:friends).and_return(@fake_user2)
        allow(@fake_user2).to receive(:find_by_user_id)
        allow(@fake_user2).to receive(:user_id)
        allow(@fake_user2).to receive(:id)
        
        allow(Visit).to receive(:find_by_id).and_return(@fake_visit)
        allow(Location).to receive(:find_by_id).and_return(@fake_location)
        allow(Visit).to receive(:where).and_return(@fake_visits)
        
        allow(@fake_visit).to receive(:id).and_return("test1")
        allow(@fake_visit).to receive(:location_id).and_return("test2")
        allow(@fake_location).to receive(:id).and_return("test3")
        allow(@fake_location).to receive(:latitude).and_return("test4")
        allow(@fake_location).to receive(:longitude).and_return("test5")
        
      end
      it "should supply past locations to map for markers w/ reviews" do
        allow(Review).to receive(:find_by). and_return(@fake_review)
        get :_past_results,:loc_id => "1",:visit_id => "1"
        expect(assigns(:location)).to eq(@fake_location)
        expect(assigns(:visit)).to eq(@fake_visit)
        expect(assigns(:review)).to eq(@fake_review)
        expect(response).to render_template(:partial => '_past_results')
      end
      it "should supply past locations to map for markers w/o reviews" do
        allow(Review).to receive(:find_by). and_return(nil)
        get :_past_results,:loc_id => "1",:visit_id => "1"
        expect(assigns(:location)).to eq(@fake_location)
        expect(assigns(:visit)).to eq(@fake_visit)
        expect(assigns(:review)).to eq(nil)
        expect(assigns(:review_exists)).to eq(false)
        expect(response).to render_template(:partial => '_past_results')
      end
      it "should supply past locations to homepage for heat map" do
        @fake_friendship = double('friendship')
        friendships = [@fake_friendship]
        allow(@fake_user).to receive(:friendships).and_return(friendships)
        allow(@fake_friendship).to receive(:friend_id)
        get :homepage
        expect(assigns(:locations)).to eq([["test4","test5"]])
        expect(assigns(:visits)).to eq([@fake_visit])
        expect(assigns(:visits_id)).to eq([["test1"]])
        expect(assigns(:locations_id)).to eq([["test3"]])
      end
    end


    describe 'GET edit' do
      before :each do
        @fake_current_user = double('current_user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_current_user)
        allow(@fake_current_user).to receive(:user_id).and_return("testid")
        allow(@fake_current_user).to receive(:inverse_friends).and_return(Array.new)
      end
      it "should render the edit user template" do
        get :edit, :id => "testid"
        expect(response).to render_template("edit")
      end
      it "should redirect to the homepage if the current user isn't valid" do
        get :edit, :id => "not"
        expect(response).to redirect_to(users_homepage_path)
      end
    end
    
    describe 'POST Update' do
      before :each do
        @fake_current_user = double('current_user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_current_user)
        allow(@fake_current_user).to receive(:user_id).and_return("testid")
        allow(@fake_current_user).to receive(:inverse_friends).and_return(Array.new)
      end
      it "should change the relevent fields if they have been changed and redirect to the homepage with a success message if it successfully saved" do
        allow(@fake_current_user).to receive(:first_name).and_return("new")
        allow(@fake_current_user).to receive(:first_name=)
        allow(@fake_current_user).to receive(:last_name).and_return("new")
        allow(@fake_current_user).to receive(:last_name=)
        allow(@fake_current_user).to receive(:gender).and_return("new")
        allow(@fake_current_user).to receive(:gender=)
        allow(@fake_current_user).to receive(:profile_pic=)
        
        allow(@fake_current_user).to receive(:save!).and_return(true)
        post :update, {:user_id => "test", :user => {:email => "fake@fake.com", :user_id => "fakeid", :password => "fakepass", :first_name => "first", :last_name => "last", :gender => "Male"}, :profile_pic => "not null"}
        expect(response).to redirect_to(users_homepage_path)
        expect(flash[:notice]).to eq("Successfully updated profile!")
      end
      it "should change the relevent fields if they have been changed and redirect to the homepage with a failure message if it failed to save" do
        allow(@fake_current_user).to receive(:first_name).and_return("new")
        allow(@fake_current_user).to receive(:first_name=)
        allow(@fake_current_user).to receive(:last_name).and_return("new")
        allow(@fake_current_user).to receive(:last_name=)
        allow(@fake_current_user).to receive(:gender).and_return("new")
        allow(@fake_current_user).to receive(:gender=)
        allow(@fake_current_user).to receive(:profile_pic=)
        
        allow(@fake_current_user).to receive(:save!).and_return(false)
        post :update, {:user_id => "test", :user => {:email => "fake@fake.com", :user_id => "fakeid", :password => "fakepass", :first_name => "first", :last_name => "last", :gender => "Male"}, :profile_pic => "not null"}
        expect(response).to redirect_to(users_homepage_path)
        expect(flash[:notice]).to eq("Unable to update profile, please try again later!")
      end
    end
    
    describe 'GET show' do
      before :each do
        @fake_current_user = double('current_user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_current_user)
        allow(@fake_current_user).to receive(:user_id).and_return("testid")
        allow(@fake_current_user).to receive(:id)
        allow(@fake_current_user).to receive(:inverse_friends).and_return(Array.new)
      end
      it "should render the show user template and set user view if user exists" do
        @fake_display_user = double('fake_display')
        allow(@fake_display_user).to receive(:id)
        allow(User).to receive(:find_by_user_id).and_return(@fake_display_user)
        get :show, :id => "test"
        expect(response).to render_template("show")
      end
      it "should redirect to the homepage if the user id isn't valid" do
        allow(User).to receive(:find_by_user_id).and_return(false)
        get :show, :id => "test"
        expect(response).to redirect_to(users_homepage_path)
        expect(flash[:notice]).to eq("User Not Found")
      end
    end
    
    describe 'POST newsfeed' do
      before :each do
        @fake_current_user = double('current_user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_current_user)
        allow(@fake_current_user).to receive(:user_id).and_return("testid")
        @fake_user = double('user')
        allow(@fake_current_user).to receive(:inverse_friends).and_return([@fake_user])
        allow(@fake_user).to receive(:id)
        allow(@fake_user).to receive(:user_id)
        allow(@fake_current_user).to receive(:friends).and_return(@fake_user)
        allow(@fake_user).to receive(:find_by_user_id)
      end
      it "should make friend's activities available to newsfeed and render partial" do
        allow(Activity).to receive(:where)
        post :newsfeed, :format => 'js'
        expect(assigns(:activities)).to eq([])
        expect(response).to render_template('newsfeed')
      end
    end
    
    describe 'POST profile_newsfeed' do
      before :each do
        @fake_current_user = double('current_user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_current_user)
        allow(@fake_current_user).to receive(:user_id).and_return("testid")
        allow(@fake_current_user).to receive(:inverse_friends).and_return(Array.new)
        @fake_user = double('user')
        allow(User).to receive(:find).and_return(@fake_user)
        allow(@fake_user).to receive(:id)
      end
      it "should make this user's activities available to newsfeed and render partial" do
        allow(Activity).to receive(:where)
        post :profile_newsfeed, :format => 'js'
        expect(assigns(:activities)).to eq([])
        expect(response).to render_template('profile_newsfeed')
      end
    end
end
