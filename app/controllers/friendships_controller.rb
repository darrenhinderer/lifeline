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
    @user = User.find(session[:user_id])
    friendship = Friendship.find(params[:id])
    friendship.selected = !friendship.selected
    friendship.save

    respond_to do |format|
      format.js {
        render(:update) { |page|
            page.replace_html :following, :partial => "friendships/following"
            page.call "loadEventsForUser", @user.id
          }
        }
    end
  end

  def destroy
    @user = User.find(session[:user_id])
    friendship = Friendship.find(params[:id])
    friendship.destroy

    respond_to do |format|
      format.js {
        render(:update) { |page|
            page.replace_html :following, :partial => "friendships/following"
            page.call "loadEventsForUser", @user.id
          }
        }
    end
  end

end
