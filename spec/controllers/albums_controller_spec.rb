require 'rails_helper'

RSpec.describe AlbumsController, type: :controller do
    before :each do
        @fake_user = double('user')
        allow(User).to receive(:find_by_session_token).and_return(@fake_user) 
        allow(@fake_user).to receive(:user_id).and_return("testid")
        allow(@fake_user).to receive(:inverse_friends).and_return(Array.new)
    end
    
    describe "GET show" do
        before :each do
            @fake_album = double('album')
            allow(Album).to receive(:find).and_return(@fake_album)
        end
        
        it "should get info from model methods if a photo/photos is/are associated" do
            @fake_photo = double('photo')
            allow(Photo).to receive(:where).and_return(@fake_photo)
            allow(@fake_album).to receive(:privacy).and_return("Everyone")
            get :show, :id => 1
            expect(assigns(:album)).to eq(@fake_album)
            expect(assigns(:photos)).to eq(@fake_photo)
        end
        
        it "should not allow users to view private albums" do
            allow(@fake_album).to receive(:privacy).and_return("Just Me")
            allow(@fake_album).to receive(:user_id).and_return("1")
            allow(@fake_user).to receive(:id).and_return("testid")
            get :show, :id => 1
            expect(response).to redirect_to(users_homepage_path)
        end
        
        it "should allow users to view friends albums" do
            @fake_feinds = "test"
            @fake_users = "test"
            allow(@fake_album).to receive(:privacy).and_return("Friends")
            allow(@fake_album).to receive(:user_id).and_return("1")
            allow(@fake_user).to receive(:id).and_return("testid2")
            allow(@fake_album).to receive(:id).and_return("1")
            allow(@fake_user).to receive(:friends).and_return(@fake_friends)
            allow(User).to receive(:find).and_return(@fake_album)
            allow(@fake_album).to receive(:friends).and_return(@fake_friends)
            allow(@fake_friends).to receive(:find).and_return(@fake_users)
            get :show, :id => 1
            expect(assigns(:current_user)).to eq(@fake_user)
        end
        
        it "should get info from model methods if no photo is associated" do
            allow(Photo).to receive(:where).and_return(nil)
            allow(@fake_album).to receive(:privacy).and_return("Everyone")
            get :show, :id => 1
            expect(assigns(:album)).to eq(@fake_album)
            expect(assigns(:photos)).to eq(nil)
        end
        
        it "should render the show album template" do
            allow(@fake_album).to receive(:privacy).and_return("Everyone")
            get :show, :id => 1
            expect(response).to render_template("show") 
        end
        
        it "should fail elegently if the album is not found at any point" do
            allow(Album).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
            get :show, :id => 1
            expect(response).to redirect_to(users_homepage_path)
        end
    end
    describe "GET new" do
        it "should render the new album template" do
            get :new
            expect(response).to render_template("new") 
        end   
    end
    describe "POST create" do
        before :each do
            @fake_album = double('album')
            @fake_photo = double('photo')
            allow(@fake_user).to receive(:id)
            allow(@fake_photo).to receive(:id).and_return(1)
            allow(@fake_photo).to receive(:update)
            allow(@fake_album).to receive(:id).and_return("test")
            allow(Photo).to receive(:create!).and_return(@fake_photo)
            allow(Album).to receive(:create!).and_return(@fake_album)
            #activity creation
            @fake_photo_data = double('photo_data')
            allow(@fake_photo).to receive(:data).and_return(@fake_photo_data)
            allow(@fake_photo_data).to receive(:url)
            allow(@fake_album).to receive(:title)
            allow(@fake_album).to receive(:privacy)
            @fake_profile_pic = double('profile_pic')
            allow(@fake_user).to receive(:profile_pic).and_return(@fake_profile_pic)
            allow(@fake_profile_pic).to receive(:url)
        end
        it "should create a new album an redirect to the show path for that album" do
            post :create, :album => {:title => "title of album", :description => "description of album"}, :cover => "1"
            expect(response).to redirect_to(album_path("test"))
        end
    end
    describe "GET edit" do
        before :each do
            @fake_album = double('album')
            @fake_photo = double('photo')
            allow(Album).to receive(:find).and_return(@fake_album)
            allow(Photo).to receive(:find).and_return(@fake_photo)
            allow(@fake_album).to receive(:album_id)
            allow(@fake_album).to receive(:cover)
            get :edit, :id => 1
        end
        it "should supply info to the template" do
            expect(assigns(:album)).to eq(@fake_album)
            expect(assigns(:photo)).to eq(@fake_photo)
        end
        it "should render the edit review template" do
            expect(response).to render_template("edit")
        end 
    end
    describe "PUT update" do
        before :each do
            @fake_album = double('album') 
            @fake_photo = double('photo')
            @fake_album2 = double('album')
            allow(Album).to receive(:find).and_return(@fake_album)
            allow(Album).to receive(:update).and_return(@fake_album2)
            allow(Photo).to receive(:create!).and_return(@fake_photo)
            allow(@fake_album).to receive(:update)
            allow(@fake_album).to receive(:id).and_return("test")
            allow(@fake_album2).to receive(:id).and_return("test")
            allow(@fake_user).to receive(:id)
        end
        it "should render the album show page with the new data" do
            put :update, :id =>1, :album => {:title => 'title', :description => "description"}, :cover => ""
            expect(response).to redirect_to(album_path("test"))
        end
        it "should render the album show page with the new data with new picture" do
            @params = {:pic => true}
            put :update, :id =>1, :album => {:title => 'title', :description => "description"}, :cover => ""
            expect(response).to redirect_to(album_path("test"))
        end
        
        it "should update the picture if a picture id was passed in" do
            allow(Photo).to receive(:create!).and_return(@fake_photo)
            allow(@fake_album).to receive(:update).and_return(true)
            allow(@fake_photo).to receive(:id).and_return(1)
            put :update, :id => 1, :pic => "test", :album => {:title => 'title', :description => "description"}
            expect(response).to redirect_to(album_path("test"))
        end
    end
    
    describe "GET index" do
        it "should supply info about albums to template" do
            @fake_album = double('album')
            allow(@fake_user).to receive(:id)
            allow(Album).to receive(:where).and_return(@fake_album)
            get :index
            expect(assigns(:photoalbums)).to eq(@fake_album)
            expect(assigns(:current_user)).to eq(@fake_user)
            expect(response).to render_template("index")
        end
    end
    describe "DELETE destroy" do
        before :each do
            @fake_album = double('album')
            allow(Album).to receive(:find).and_return(@fake_album)
            allow(@fake_album).to receive(:destroy!)
            delete :destroy, :id => 1
        end
        it 'should redirect to homepage' do
            expect(response).to redirect_to(albums_path)
        end
    end
end
