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
      end
      it 'autocomplete should return user info' do
        get :index, {:format => :json, :term => 'abc'}
        response.should be_success
      end
      it "should supply results to template" do
        @fake_user_result = double(['user_result'])
        allow(User).to receive(:where).and_return(@fake_user_result)
        get :index, {:link => {:origin_id => 1}}
        expect(assigns(:users)).to eq(@fake_user_result)
        expect(response).to render_template("index")
      end
    end
    describe 'searching for yelp results ' do
      before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user)
      end
      it "should supply results to template" do
        get :_yelp_results,:term => "hotel",:latitude => "41.669088",:longitude => "-91.563481",:address => "87 2nd St, Coralville, IA 52241",:name =>"heartland inn"
        expect(assigns(:results).businesses[0].name).to eq("Heartland Inn")
        expect(assigns(:street)).to eq("87 2nd St")
        expect(response).to render_template(:partial => '_yelp_results')
      end
    end
end

