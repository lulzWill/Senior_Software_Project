class PhotosController < ApplicationController
    before_filter :set_current_user
    
    def show
        @photo = Photo.find(params[:id])
    end
    
    def new
        @album_id = params[:album_id]
    end
    
    def create
        @test = params[:album_id]
        if @test == ""
            @photo = Photo.create!(user_id: @current_user.id, description: params[:photo][:description], title: params[:photo][:title], data: params[:pic])
            data_hash = {url: @photo.data.url, title: @photo.title, photo_id: @photo.id}
            Activity.create!(user_id: @photo.user_id, username: @current_user.user_id, activity_type: "photo", data: data_hash)
            flash[:notice] = "Photo added!"
            redirect_to photo_path(@photo.id)
        else
            @photo = Photo.create!(user_id: @current_user.id, album_id: params[:album_id], description: params[:photo][:description], title: params[:photo][:title], data: params[:pic])
            data_hash = {url: @photo.data.url, title: @photo.title, photo_id: @photo.id, privacy: @photo.album.privacy}
            Activity.create!(user_id: @current_user.id, username: @current_user.user_id, profile_pic: @current_user.profile_pic.url, activity_type: "photo", data: data_hash)
            flash[:notice] = "Photo added to album!"
            redirect_to album_path(params[:album_id])
        end
    end
    
    def edit
        @photo = Photo.find(params[:id])
    end

    def update
        @photo = Photo.find(params[:id])
        @photo.update(description: params[:photo][:description], title: params[:photo][:title])
        flash[:notice] = "Photo updated!"
        redirect_to photo_path(@photo.id)
    end
    
    def destroy
        Photo.find(params[:id]).destroy
        flash[:notice] = "Photo deleted!"
        redirect_to users_homepage_path
    end
    
end
