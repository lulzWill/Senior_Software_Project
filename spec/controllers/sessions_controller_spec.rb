require 'rails_helper'
require 'spec_helper'
require 'users_controller'
require 'application_controller'

describe SessionsController do
    describe 'logging out' do
        it 'remove session token' do
            get :destroy 
            expect(cookies[:session_token]).to be_nil
        end
        
        it 'remove current user' do
            get :destroy
            expect(@current_user).to be_nil
        end
        
        it 'notify user' do
            get :destroy
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
          expect(flash[:warning]).to eq "Invalid User-ID/Password combination" 
       end
    end
end