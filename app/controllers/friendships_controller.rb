class FriendshipsController < ApplicationController
    before_filter :set_current_user
    
    def create
        @friendship = @current_user.friendships.build(:friend_id => params[:friend][:user_id])
        if @friendship.save
            user_id = User.find(params[:friend][:user_id]).user_id
            flash[:notice] = "Added #{user_id} as a friend!"
            redirect_to(:back)
        else
            flash[:notice] = "Unable to add friend!"
            redirect_to(:back)
        end
    end
end
