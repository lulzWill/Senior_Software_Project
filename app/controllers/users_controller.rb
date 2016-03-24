class UsersController < ApplicationController
    before_filter :set_current_user, :only => ['index', 'show', 'homepage', 'edit', 'update', 'delete', 'newsfeed']



    def edit
        if(params[:id] != @current_user.user_id)
            flash[:notice] = "You cannot edit someone else's profile!"
            redirect_to users_homepage_path
        end
    end
    
    def update
        if @current_user.first_name != params[:user][:first_name]
            @current_user.first_name = params[:user][:first_name]
        end
        if @current_user.last_name != params[:user][:last_name]
            @current_user.last_name = params[:user][:last_name]
        end
        if @current_user.gender != params[:user][:gender]
            @current_user.gender = params[:user][:gender]
        end
        if params[:profile_pic] != ""
            @current_user.profile_pic = params[:profile_pic]
        end
        
        if @current_user.save!
            flash[:notice] = "Successfully updated profile!"
            redirect_to '/users/homepage'
        else
            flash[:notice] = "Unable to update profile, please try again later!"
            redirect_to '/users/homepage'
        end
        
    end

    
    def homepage
        @friendships = @current_user.friendships
        @friend_ids = []
        @friendships.each do |friendship|
           @friend_ids << friendship.friend_id
        end
        @activities = Activity.limit(10).order('created_at DESC').where(user_id: @friend_ids)
        @offset = 10
    end
    
    def _yelp_results
        require 'yelp'
        
        @client = Yelp::Client.new({ consumer_key: "qFgM8s-8qX8S9rLPQzyUww",
                            consumer_secret: "CAhKkIHV80-vvye3adW6n9elIc8",
                            token: "rY_h4iOL723V7fgaRiODf2lERRWaAb-u",
                            token_secret: "RiABUM7_ORCKm_FBGH1s0mUUiNo"
                          })
                          
        @name = params[:name]
        @searchTerm = params[:term]
        @longitude = params[:longitude]
        @latitude = params[:latitude]
        @address = params[:address]
        
        @coords = {latitude: @latitude,longitude: @longitude}
        
        @results = @client.search_by_coordinates(@coords, {term: @name,limit:1,radius_filter:100})
        @street = @results.businesses[0].location.address
        @street = @street.inspect
        @street[0]=""
        @street[0]=""
        @street.chop!
        @street.chop!
        render :partial =>'yelp_results', :object =>@results and return if request.xhr?
    end
    
    def show
        if User.find_by_user_id(params[:id])
            @user_view = User.find_by_user_id(params[:id])
        else
            flash[:notice] = "User Not Found"
            redirect_to users_homepage_path
        end
    end
    
    def index
        if request.format == :json
            @users = User.where("user_id LIKE :q", { q: "#{params[:term]}%"})
        else
            @users = User.where("user_id LIKE :q", { q: "#{params[:link][:origin_id]}%"}) 
        end
        respond_to do |format|
            format.json{ render :json => @users.as_json(:only => [:first_name,:last_name,:user_id,:id,:profile_pic]) }
            format.html
        end
    end

    def user_params
        params.require(:user).permit(:email, :user_id, :password, :first_name, :last_name, :gender)
    end
    
    def new
        if cookies[:session_token]
            flash[:notice]="You are already logged in"
            redirect_to '/users/homepage'
        end
    end
    
    def create
        if(!User.find_by_user_id(params[:user][:user_id]))
            params_hash = {:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :gender => params[:user][:gender], :email => params[:user][:email], :user_id => params[:user][:user_id], :role => "user", :password => params[:user][:password], :profile_pic => params[:profile_pic]} 
            @user = User.new(params_hash)
            if @user.save
                #create default album
                #Album.create!(user_id: @user.id, title: 'User pics', description:'',)
                #UserMailer.welcome_email(@user).deliver_now
                flash[:notice] = "Welcome #{params[:user][:first_name]}! You have successfully signed up as a User of Backpack Traveler!"
                redirect_to new_user_path
            else
                flash[:notice] = "Sorry, something went wrong. Please try again"
                redirect_to new_user_path
            end
        else
            flash[:notice] = "Sorry, but that user id is already taken"
            redirect_to new_user_path
        end
    end
    
    def autocomplete
        
    end
    
    def newsfeed
        @friendships = @current_user.friendships
        @friend_ids = []
        @friendships.each do |friendship|
           @friend_ids << friendship.friend_id
        end
        @activities = Activity.limit(10).order('created_at DESC').where(user_id: @friend_ids).offset(params[:offset])
        @offset = params[:offset].to_i + 10
        respond_to do |format|
            format.js {}
        end
    end
    
end

