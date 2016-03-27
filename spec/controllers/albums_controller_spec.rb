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
            allow(Album).to receive(:find).and_return(@fake_album)
            allow(@fake_album).to receive(:update)
            allow(@fake_album).to receive(:id).and_return("test")
            allow(@fake_user).to receive(:id)
        end
        it "should render the album show page with the new data" do
            put :update, :id =>1, :album => {:title => 'title', :description => "description"}, :cover => ""
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
