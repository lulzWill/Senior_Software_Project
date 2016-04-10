FactoryGirl.define do
 factory :data do
   photo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/myfiles/myfile.jpg')))
 end
end