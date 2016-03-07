require 'rails_helper'
require 'spec_helper'

RSpec.describe FriendshipsController, type: :controller do
    describe 'POST create' do
      before :each do
        @fake_current_user = double('current_user')
        @fake_friendship = double('current_friendship')
        allow(@fake_current_user).to receive(:friendships).and_return(@fake_friendship)
        allow(@fake_friendship).to receive(:build).and_return(@fake_friendship)
        allow(User).to receive(:find_by_session_token).and_return(@fake_current_user)
        allow(@fake_current_user).to receive(:user_id).and_return("testid")
        allow(@fake_current_user).to receive(:inverse_friends).and_return(Array.new)
      end
      it "should redirect back when a friend is successfully added" do
        @request.env['HTTP_REFERER'] = 'http://test.com/users/homepage'
        @fake_user = double('fake_user')
        allow(@fake_friendship).to receive(:save).and_return(true)
        allow(User).to receive(:find).and_return(@fake_user)
        allow(@fake_user).to receive(:user_id).and_return("test")
        post :create, :friend => {:user_id => "test"}
        expect(response).to redirect_to(:back)
        expect(flash[:notice]).to eq("Added test as a friend!")
      end
      it "should redirect back when a friend fails to add" do
        @request.env['HTTP_REFERER'] = 'http://test.com/users/homepage'
        @fake_user = double('fake_user')
        allow(@fake_friendship).to receive(:save).and_return(false)
        post :create, :friend => {:user_id => "test"}
        expect(response).to redirect_to(:back)
        expect(flash[:notice]).to eq("Unable to add friend!")
      end
    end
end
