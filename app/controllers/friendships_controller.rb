class FriendshipsController < ApplicationController

  def create
    session[:user_id] = User.find(:first).user_id
    @current_user = User.find(session[:user_id])

    friendship = @current_user.friendships.build(:friend_id => params[:friend_id])  
    if @friendship.save  
      flash[:notice] = "Added friend."  
    else  
      flash[:notice] = "Unable to add friend."  
    end
    redirect_to :back
  end

end
