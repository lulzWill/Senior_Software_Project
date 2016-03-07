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
        allow(@fake_current_user).to receive(:inverse_friends).and_return(Array.new)
      end
      it "should render the show user template and set user view if user exists" do
        @fake_display_user = double('fake_display')
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
end