class UsersController < ApplicationController

  def index
    @users = User.search(params[:query], params[:page])
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def activity
    @latest = Event.init_latest()
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(params[:id])
    @event = Event.new(:start_date => Time.now)
    respond_to do |format|
      format.html # show.html.erb
      format.json {
        data = {"events" => collect_events(@user)}
        render :json => data.to_json
      }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end

  def update_friendship
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

  def destroy_friendship
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

private
  def collect_events user
    all_events = []
    user.events.each do |event|
      editable = (event.user_id == session[:user_id])
      all_events << event.to_timeline(editable)
    end
    user.friendships.each do |friendship|
      if friendship.selected
        more_events = Event.all_public(friendship.friend)
        more_events.each do |event|
          editable = (event.user_id == session[:user_id])
          event.title = "[" + friendship.friend.username + "] " + event.title
          all_events << event.to_timeline(editable)
        end
      end
    end
    all_events
  end
end
