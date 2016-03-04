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
        redirect_to album_path(@album.id)
    end
    
    def edit
        @album = Album.find(params[:id])
    end
    
    def update
        @album = Album.update(user_id: @current_user.id, description: params[:album][:description], title: params[:album][:title], cover: params[:pic])
        redirect_to album_path(@album.id)
    end
    
    def destroy
        Album.find(params[:id]).destroy!
        redirect_to albums_path
    end
    
end
