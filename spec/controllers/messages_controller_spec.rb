require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
    before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user)
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
    end
    describe 'POST create' do
        before :each do
            @fake_con = double('conversation')
            @fake = double('message')
            @fake_mes = double('message')
            @mes = double('message')
            allow(Conversation).to receive(:find).and_return(@fake_con)
            allow(@fake_user).to receive(:id).and_return(1)
            allow(@fake_mes).to receive(:user_id=).and_return(1)
            allow(@fake_con).to receive(:messages).and_return(@fake)
            allow(@fake).to receive(:build).and_return(@fake_mes)
            allow(@fake_mes).to receive(:body).and_return("hello")
            allow(@fake_mes).to receive(:save!).and_return(true)
            post :create, :user_id => 1, :id => 1, :conversation_id => 2, :message => {:body => "hello"}
        end
        it 'should create a conversation' do
            expect(assigns(:conversation)).to eq(@fake_con)
            expect(assigns(:message)).to eq(@fake_mes)
        end
    end
end
