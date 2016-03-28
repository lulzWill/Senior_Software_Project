class AlbumsController < ApplicationController
    before_filter :set_current_user
    
    def index
        @photoalbums = Album.where(user_id: @current_user.id)
    end
    
    def show
        @album = Album.find(params[:id])
        @photos = Photo.where(album_id: params[:id])
    end
    
    def new 
        
    end
    
    def create
        @photo = Photo.create!(user_id: @current_user.id, description: params[:album][:description], title: params[:album][:title], data: params[:pic])
        @album = Album.create!(user_id: @current_user.id, description: params[:album][:description], title: params[:album][:title], cover: @photo.id)
        @photo.update(album_id: @album.id)
        data_hash = {url: @photo.data.url, title: @album.title, album_id: @album.id}
        Activity.create!(user_id: @current_user.id, username: @current_user.user_id, profile_pic: @current_user.profile_pic.url, activity_type: "album", data: data_hash)
        flash[:notice] = "Album Added"
        redirect_to album_path(@album.id)
    end
    
    def edit
        @album = Album.find(params[:id])
        @photo = Photo.find(@album.cover)
    end
    
    def update
        @album = Album.find(params[:id])
        @photo = Photo.create!(user_id: @current_user.id,album_id: @album.id, description: params[:album][:description], title: params[:album][:title], data: params[:pic])
        @album.update(user_id: @current_user.id, description: params[:album][:description], title: params[:album][:title], cover: @photo.id)
        flash[:notice] = "Album Updated"
        redirect_to album_path(@album.id)
    end
    
    def destroy
        Album.find(params[:id]).destroy!
        flash[:notice] = "Album Deleted"
        redirect_to albums_path
    end
    
end
