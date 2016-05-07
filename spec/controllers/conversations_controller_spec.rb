require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
    before :each do
        @fake_user = double('user')
        @fake_mes = double('message')
        @fake_con = double('conversation')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user) 
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
        allow(@fake_user).to receive(:id).and_return(1)
        allow(@fake_con).to receive(:id).and_return(1)
        allow(@fake_con).to receive(:recipient_id).and_return(1)
        allow(@fake_con).to receive(:recipient).and_return(1)
        allow(@fake_con).to receive(:sender_id).and_return(2)
        allow(@fake_con).to receive(:sender).and_return(2)
        allow(@fake_con).to receive(:present?).and_return(true)
        allow(@fake_con).to receive(:messages).and_return("hi")
        allow(Message).to receive(:new).and_return(@fake_mes)
        allow(Conversation).to receive(:find).and_return(@fake_con)
        allow(Conversation).to receive(:between).and_return(@fake_con)
    end
    describe "create" do
        it 'should find a message if it exists' do
            allow(Conversation).to receive(:between).and_return(@fake_con)
            allow(@fake_con).to receive(:present?).and_return(true)
            allow(@fake_con).to receive(:first).and_return(@fake_con)
            expect(assigns(:conversation)).to eq(nil)
            post :create, :sender_id => "1", :recipient_id => "2"
        end
        it 'should create a new message if it does not' do
            allow(Conversation).to receive(:between).and_return(false)
            post :create, :sender_id => "1", :recipient_id => "2"
        end
    end
    describe "show" do
        it 'should show a message' do
            get :show, :id => 1
            allow(Conversation).to receive(:find).and_return(@fake_con)
            expect(assigns(:receiver)).to eq(nil)
            expect(assigns(:messages)).to eq(@fake_con.messages)
            expect(assigns(:message)).to eq(Message.new)
        end
    end
end
