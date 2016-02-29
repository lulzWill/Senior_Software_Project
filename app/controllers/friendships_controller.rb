class FriendshipsController < ApplicationController
    before_filter :set_current_user
    
    def create
        @friendship = @current_user.friendships.build(:friend_id => params[:friend][:user_id])
        if @friendship.save
            flash[:notice] = "Successfully added #{params[:friend][:user_id]} as a friend!"
            redirect_to root_url
        else
            flash[:notice] = "Unable to add friend!"
            redirect_to root_url
        end
    end
end
