require 'rails_helper'
require 'spec_helper'

RSpec.describe LocationsController, type: :controller do
    
    describe "GET show" do
        before :each do
            @fake_location_results = double('location1')
            allow(Location).to receive(:find_or_create_by!).and_return(@fake_location_results)
            allow(@fake_location_results).to receive(:id)
            allow(Review).to receive(:where)
        end
        it "should collect the information for that location" do
            expect(Location).to receive(:find_or_create_by!)
            expect(Review).to receive(:where)
            get :show, {:id => 1}
        end
        it "should render the show location view" do
            get :show, {:id => 1}
            expect(response).to render_template(:show) 
        end
    end
end
