class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def set_current_user
    if cookies[:session_token]
      @current_user ||= User.find_by_session_token(cookies[:session_token])
      
      if @current_user
        @friend_requests = Array.new
        
        @current_user.inverse_friends.each do |inverse_friend|
          if !@current_user.friends.find_by_user_id(inverse_friend.user_id)
            @friend_requests << inverse_friend
          end
        end
      end
      redirect_to new_user_path unless @current_user
    else 
      redirect_to new_user_path
    end
  end
end
