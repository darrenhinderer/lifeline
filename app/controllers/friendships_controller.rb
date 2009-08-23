class FriendshipsController < ApplicationController

  def create
    @current_user = User.find(session[:user_id])
    friend = User.find(params[:friend_id])

    if !@current_user.is_friend?(friend)
      friendship = @current_user.friendships.build(:friend_id => friend.id)  
      if friendship.save  
        flash[:notice] = "Added friend."  
      else  
        flash[:notice] = "Unable to add friend."  
      end
      redirect_to :back
    end
  end

  def update
    puts "TESTING"
    render_partial :following    
  end

end
