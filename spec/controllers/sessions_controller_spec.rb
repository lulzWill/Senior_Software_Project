require 'rails_helper'
require 'spec_helper'
require 'users_controller'
require 'application_controller'

describe SessionsController do
    describe 'new session' do
       it 'takes to new session page' do
            get :new
            expect(response).to render_template("new")
       end
    end
    describe 'logging out' do
        it 'deletes session' do
           get :destroy
           @fake_session = double('session')
           expect(cookies[:session_token]).to be_nil
           expect(@current_user).to be_nil
           expect(flash[:notice]).to eq "You have logged out"
        end
    end
    describe 'valid login' do
        before(:each) do
            user = FactoryGirl.create(:user)
            post :create, {:session => {:user_id => 'admin', :password => 'admin1'}}
        end
        
        it 'set session token' do
           expect(cookies[:session_token]).to_not be_nil 
        end
        
        it 'creates a current user' do
           expect(assigns(@current_user)).to_not be_nil 
        end
        
        it 'redirects to home path' do 
           expect(response).to redirect_to("/users/homepage") 
        end
    end
    
    describe 'invalid login' do
       before(:each) do
           post :create, {:session => {:user_id => 'nope', :password => ''}} 
       end
        
       it 'redirect_to login path' do
          expect(response).to redirect_to(new_user_path) 
       end
       
       it 'notifies user' do
          expect(flash[:warning]).to eq "invalid User-ID/Password combination" 
       end
    end
    
    describe 'already logged in' do
        it 'redirect to homepath and flash notice' do
            user = FactoryGirl.create(:user)
            post :create, {:session => {:user_id => 'admin', :password => 'admin1'}}
            get :new
            expect(flash[:notice]).to eq "You have successfully logged in as admin"
            #expect(response).to redirect_to("users/homepath")
        end
    end
end