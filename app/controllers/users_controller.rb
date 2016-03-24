class UsersController < ApplicationController
    before_filter :set_current_user, :only => ['index', 'show', 'homepage', 'edit', 'update', 'delete']

    
    def homepage
    
    end
    
    def _yelp_results
        require 'yelp'
        
        @client = Yelp::Client.new({ consumer_key: "qFgM8s-8qX8S9rLPQzyUww",
                            consumer_secret: "CAhKkIHV80-vvye3adW6n9elIc8",
                            token: "rY_h4iOL723V7fgaRiODf2lERRWaAb-u",
                            token_secret: "RiABUM7_ORCKm_FBGH1s0mUUiNo"
                          })
                          
        @name = params["name"]
        @searchTerm = params[:term]
        @longitude = params[:longitude]
        @latitude = params[:latitude]
        
        @coords = {latitude: @latitude,longitude: @longitude}
        
        @results = @client.search_by_coordinates(@coords, { term: @name,limit:1})
        @street = @results.businesses[0].location.address
        @street = @street.inspect
        @street[0]=""
        @street[0]=""
        @street.chop!
        @street.chop!
        render :partial =>'yelp_results', :object =>@results and return if request.xhr?
    end
    
    def show
        
    end
    
    def index
      @users = User.where.not("id = ?",@current_user.id).order("created_at DESC")
      @conversations = Conversation.involving(@current_user).order("created_at DESC")
    end

    def user_params
        params.require(:user).permit(:email, :user_id, :password, :first_name, :last_name, :gender)
    end
    
    def new
        if cookies[:session_token]
            flash[:notice]="You are already logged in"
            redirect_to users_homepage_path
        end
    end
    
    def create
        if(!User.find_by_user_id(params[:user][:user_id]))
            params_hash = {:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :gender => params[:user][:gender], :email => params[:user][:email], :user_id => params[:user][:user_id], :role => "user", :password => params[:user][:password], :profile_pic => params[:profile_pic]} 
            @user = User.new(params_hash)
            if @user.save
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
end

