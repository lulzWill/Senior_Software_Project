require 'rails_helper'

RSpec.describe Visit, type: :model do
    
    before :each do
        @fake_start = "2000-1-1"
        @fake_visit = double('visit1')
        allow(@fake_visit).to receive(:start_date).and_return(@fake_start)
        
    end
    describe "get Visit dates formatted for presentation" do
        before :each do
            allow(Visit).to receive(:find).and_return(@fake_visit) 
        end
        it "should return one date if start and end are the same" do
            @fake_end = "2000-1-1"
            allow(@fake_visit).to receive(:end_date).and_return(@fake_end)
            result = Visit.get_dates(1)
            expect(result).to eq(@fake_start)
        end
        
        it "should return two dates if start and end are different" do
            @fake_end = "2000-1-2"
            allow(@fake_visit).to receive(:end_date).and_return(@fake_end)
            result = Visit.get_dates(1)
            expect(result).to eq(@fake_start + " to " + @fake_end)
        end
    end
    
    describe "check dates for overlap with previous visits" do
        context 'other visits exist' do
            before :each do
                @fake_end = "2000-1-2"
                allow(@fake_visit).to receive(:end_date).and_return(@fake_end)
                allow(Visit).to receive(:where).and_return([@fake_visit])
            end
            it "should return false if there's no overlap" do
                expect(Visit.overlap?(1,1,"1999-1-1","1999-1-1")).to be_falsey
            end
            
            it "should return true if overlap is found" do
                expect(Visit.overlap?(1,1,"2000-1-1","2000-1-1")).to be_truthy
            end
        end
        context 'other visits do not exist' do
            it "should return false since overlap cannot occur" do
                allow(Visit).to receive(:where).and_return(nil)
                expect(Visit.overlap?(1,1,"1999-1-1","1999-1-1")).to be_falsey
            end
        end
    end
  
end
