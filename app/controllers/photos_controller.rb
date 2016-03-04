class PhotosController < ApplicationController
    before_filter :set_current_user
    
    def show
        @photo = Photo.find(params[:id])
    end
    
    def new
        @album_id = params[:album_id]
    end
    
    def create
        if params[:album_id].nil?
            @photo = Photo.create!(user_id: @current_user.id, description: params[:photo][:description], title: params[:photo][:title], data: params[:pic])
            redirect_to photo_path(@photo.id)
        else
            @photo = Photo.create!(user_id: @current_user.id, album_id: params[:album_id], description: params[:photo][:description], title: params[:photo][:title], data: params[:pic])
            redirect_to album_path(params[:album_id])
        end
    end
    
    def edit
        @photo = Photo.find(params[:id])
    end

    def update
        @photo = Photo.find(params[:id])
        @photo.update(description: params[:photo][:description], title: params[:photo][:title])
        redirect_to photo_path(@photo.id)
    end
    
    def destroy
        Photo.find(params[:id]).destroy
        redirect_to users_homepage_path
    end
    
end
