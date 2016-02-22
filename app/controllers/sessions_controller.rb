class SessionsController < ApplicationController
    skip_before_filter :set_current_user
    
    def create
        user = User.find_by_user_id(params[:session][:user_id])
        if user && user.authenticate(params[:session][:password])
            user.session_token = SecureRandom.urlsafe_base64
            user.save!
            cookies.permanent[:session_token]=user.session_token
            flash[:notice] = "You have successfully logged in as #{params[:session][:user_id]}"
            redirect_to "/users/homepage"
        else
            flash[:warning] = "Invalid User-ID/Password combination"
            redirect_to new_user_path
        end
    end
    
    def destroy
        cookies.delete(:session_token)
        @current_user=nil
        flash[:notice] = "You have logged out"
        redirect_to new_user_path
    end
end