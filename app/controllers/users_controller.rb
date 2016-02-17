class UsersController < ApplicationController
    def homepage
    end
    
    def show
        
    end
    
    def index
        
    end
    
    def create
        
    end
    
    def new

    def user_params
        params.require(:user).permit(:email, :user_id, :password, :first_name, :last_name, :gender)
    end
    
    def new
    #render new template
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

