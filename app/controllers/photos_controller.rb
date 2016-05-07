class PhotosController < ApplicationController
    before_filter :set_current_user
    
    def show
        @photo = Photo.find(params[:id])
        if @photo.privacy == "Just Me" && @current_user.id != @photo.user_id
            flash[:notice] = "You do not have permission to view this photo"
            redirect_to users_homepage_path
        elsif @photo.privacy == "Friends" && @current_user.id != @photo.user_id
            user = User.find(@photo.user_id)
            if !(user.friends.find(@current_user.id) && @current_user.friends.find(user.id))
                #fails if record is not found and redirects
            end
        end
        
        rescue ActiveRecord::RecordNotFound
            flash[:notice] = "You do not have permission to view this photo"
            redirect_to users_homepage_path
    end
    
    def new
        @album_id = params[:album_id]
    end
    
    def create
        @test = params[:album_id]
        if @test == ""
            @photo = Photo.create!(user_id: @current_user.id, description: params[:photo][:description], title: params[:photo][:title], data: params[:pic], privacy: params[:photo][:privacy])
            data_hash = {url: @photo.data.url, title: @photo.title, photo_id: @photo.id}
            Activity.create!(user_id: @photo.user_id, username: @current_user.user_id, activity_type: "photo", data: data_hash)
            flash[:notice] = "Photo added!"
            redirect_to photo_path(@photo.id)
        else
            @photo = Photo.create!(user_id: @current_user.id, album_id: params[:album_id], description: params[:photo][:description], title: params[:photo][:title], data: params[:pic], privacy: params[:photo][:privacy])
            data_hash = {url: @photo.data.url, title: @photo.title, photo_id: @photo.id}

            Activity.create!(user_id: @current_user.id, username: @current_user.user_id, profile_pic: @current_user.profile_pic, activity_type: "photo", data: data_hash)
            flash[:notice] = "Photo added to album!"
            redirect_to album_path(params[:album_id])
        end
    end
    
    def edit
        @photo = Photo.find(params[:id])
    end

    def update
        @photo = Photo.find(params[:id])
        @photo.update(description: params[:photo][:description], title: params[:photo][:title], privacy: params[:photo][:privacy])
        flash[:notice] = "Photo updated!"
        redirect_to photo_path(@photo.id)
    end
    
    def destroy
        Photo.find(params[:id]).destroy
        flash[:notice] = "Photo deleted!"
        redirect_to users_homepage_path
    end
    
    def flag_photo
        PhotoFlag.create!(user_id: @current_user.id, photo_id: params[:photo_id])
        photo = Photo.find(params[:review_id])
        if photo.photo_flags.count >= 3
            photo.update(flagged: true)
        end
        render :nothing => true
    end
end
