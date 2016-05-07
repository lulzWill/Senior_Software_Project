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
            allow(@fake_user).to receive(:id).and_return(1)
            allow(@fake_photo).to receive(:user_id).and_return(2)
        end
        it "should get info from model method for 'Just Me' photo if " do
            allow(@fake_photo).to receive(:privacy).and_return("Just Me")
            get :show, :id => 1
            expect(assigns(:photo)).to eq(@fake_photo)
        end
        it "should get info from model method for 'Friends' photo if " do
            allow(@fake_photo).to receive(:privacy).and_return("Friends")
            @fake_user2 = double('user2')
            @fake_friends = double('friends')
            allow(User).to receive(:find).and_return(@fake_user2)
            allow(@fake_user).to receive(:friends).and_return(@fake_friends)
            allow(@fake_user2).to receive(:friends).and_return(@fake_friends)
            allow(@fake_friends).to receive(:find).and_return(@fake_users)
            get :show, :id => 1
            expect(assigns(:photo)).to eq(@fake_photo)
        end
        it "should get info from model method for 'Everyone' photo if " do
            allow(@fake_photo).to receive(:privacy).and_return("Everyone")
            get :show, :id => 1
            expect(assigns(:photo)).to eq(@fake_photo)
        end
        it "should render the show photo template" do
            allow(@fake_photo).to receive(:privacy).and_return("Everyone")
            get :show, :id => 1
            expect(response).to render_template("show") 
        end
        it "should fail elegently if the photo is not found at any point" do
            allow(Photo).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
            get :show, :id => 1
            expect(response).to redirect_to(users_homepage_path)
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
            #activity creation
            @fake_photo_data = double('photo_data')
            allow(@fake_photo).to receive(:title)
            allow(@fake_photo).to receive(:user_id)
            @fake_album = double('album')
            allow(@fake_photo).to receive(:album).and_return(@fake_album)
            allow(@fake_album).to receive(:privacy)
            allow(@fake_photo).to receive(:data).and_return(@fake_photo_data)
            allow(@fake_photo_data).to receive(:url)
            @fake_profile_pic = double('profile_pic')
            allow(@fake_user).to receive(:profile_pic).and_return(@fake_profile_pic)
            allow(@fake_profile_pic).to receive(:url)
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
    
    
    describe 'GET flag_photo' do
        before :each do
            allow(PhotoFlag).to receive(:create!)
            allow(@fake_user).to receive(:id)
        end
        it "set photo as flagged if >=3 flags and render nothing" do
            fake_photo = double('fake_photo')
            flags = double('flags')
            allow(Photo).to receive(:find).and_return(fake_photo)
            allow(fake_photo).to receive(:photo_flags).and_return(flags)
            allow(flags).to receive(:count).and_return(3)
            expect(fake_photo).to receive(:update)
            expect(response.body).to be_blank
            get :flag_photo, :photo_id =>1
        end
    end
end
