require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the VisitsHelper. For example:
#
# describe VisitsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do
  describe 'interlocutor' do
      it 'should help' do
          @fake_con = double('conversation')
          allow(@fake_con).to receive(:recipient).and_return(1)
      end
  end
end