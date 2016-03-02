class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def set_current_user
      @current_user ||= User.find_by_session_token(cookies[:session_token])
      @friend_requests = Array.new
      
      @current_user.inverse_friends.each do |inverse_friend|
        if !@current_user.friends.find_by_user_id(inverse_friend.user_id)
          @friend_requests << inverse_friend
        end
      end
      redirect_to new_user_path unless @current_user
  end
end
