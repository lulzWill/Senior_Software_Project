require 'rails_helper'

RSpec.describe PhotosController, type: :controller do

    before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user)
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
    end
    
    describe "GET show" do
        before :each do
            @fake_photo = double('photo')
            allow(Photo).to receive(:find).and_return(@fake_photo)
        end
        
        it "should get info from model method for the photo" do
            get :show, :id => 1
            expect(assigns(:photo)).to eq(@fake_photo)
        end
        
        it "should render the show photo template" do
            get :show, :id => 1
            expect(response).to render_template("show") 
        end
            
    end
    describe "GET new" do
        it "should render the new photo template" do
            get :new
            expect(response).to render_template("new") 
        end   
    end
    describe "POST create" do
        before :each do
            @fake_photo = double('photo')
            allow(@fake_user).to receive(:id)
            allow(@fake_photo).to receive(:id).and_return(1)
            allow(Photo).to receive(:create!).and_return(@fake_photo)
        end
        it "should create a new photo and redirect to the show path for that album (when created from album)" do
            @fake_album = double('album')
            allow(Album).to receive(:create!).and_return(@fake_album)
            post :create, :photo => {:title => "abc", :description => "defg"}, :album_id => 1
            expect(response).to redirect_to(album_path(1))
        end
        it "should create a new photo an redirect to the show path for that photo" do
            post :create, :photo => {:title => "abc", :description => "defg"}, :pic => "1", :album_id => ""
            expect(response).to redirect_to(photo_path(1))
        end
    end
    describe "GET edit" do
        before :each do
            @fake_photo = double('photo')
            allow(Photo).to receive(:find).and_return(@fake_photo)
            get :edit, :id => 1
        end
        it "should supply info to the template" do
            expect(assigns(:photo)).to eq(@fake_photo)
        end
        it "should render the edit review template" do
            expect(response).to render_template("edit")
        end 
    end
    describe "PUT update" do
        before :each do
            @fake_photo = double('photo') 
            allow(Photo).to receive(:find).and_return(@fake_photo)
            allow(@fake_photo).to receive(:update)
            allow(@fake_photo).to receive(:id).and_return(1)
            allow(@fake_user).to receive(:id)
        end
        it "should render the album show page with the new data" do
            put :update, :id =>1, :photo => {:title => 'title', :description => "description"}
            expect(response).to redirect_to(photo_path(1))
        end
    end
    describe "DELETE destroy" do
        before :each do
            @fake_photo = double('photo')
            allow(Photo).to receive(:find).and_return(@fake_photo)
            allow(@fake_photo).to receive(:destroy)
            delete :destroy, :id => 1
        end
        it 'should redirect to homepage' do
            expect(response).to redirect_to(users_homepage_path)
        end
    end
end
