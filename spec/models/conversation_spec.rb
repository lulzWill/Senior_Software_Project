require 'rails_helper'

RSpec.describe Conversation, type: :model do
  before :each do
     @fake_con = double('conversation') 
     allow(@fake_con).to receive(:scope).and_return(:between)
     @fake_user1 = double('user')
     @fake_user2 = double('user') 
  end
  describe "involving" do
      it 'show conversations involving' do
          
      end        
  end
  describe "between" do
      it 'show conversations between' do
          @fake_con.scope == :between 
          allow(@fake_con).to receive(:where).and_return("fake")
      end
  end
end
