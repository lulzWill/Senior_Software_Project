class AlbumsController < ApplicationController
    before_filter :set_current_user
    
    def index
        @photoalbums = Album.where(user_id: @current_user.id)
    end
    
    def show
        @album = Album.find(params[:id])
        if @album.privacy == "Just Me" && @current_user.id != @album.user_id
            flash[:notice] = "You do not have permission to view this album"
            redirect_to users_homepage_path
        elsif @album.privacy == "Friends" && @current_user.id != @album.user_id
            user = User.find(@album.user_id)
            if !(user.friends.find(@current_user.id) && @current_user.friends.find(user.id))
                #fails if record is not found and redirects
            end
        end
        @photos = Photo.where(album_id: params[:id])
        
        rescue ActiveRecord::RecordNotFound
            flash[:notice] = "You do not have permission to view this album"
            redirect_to users_homepage_path
    end
    
    def new 
        
    end
    
    def create
        @photo = Photo.create!(user_id: @current_user.id, description: params[:album][:description], title: params[:album][:title], data: params[:pic])
        @album = Album.create!(user_id: @current_user.id, description: params[:album][:description], title: params[:album][:title], cover: @photo.id,  privacy: params[:album][:privacy])
        @photo.update(album_id: @album.id)
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
        @album.update(user_id: @current_user.id, description: params[:album][:description], title: params[:album][:title], cover: @photo.id,  privacy: params[:album][:privacy])
        flash[:notice] = "Album Updated"
        redirect_to album_path(@album.id)
    end
    
    def destroy
        Album.find(params[:id]).destroy!
        flash[:notice] = "Album Deleted"
        redirect_to albums_path
    end
    
end
