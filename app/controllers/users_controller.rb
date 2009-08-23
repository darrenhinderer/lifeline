class UsersController < ApplicationController

  def index
    @users = User.search(params[:query], params[:page])
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(params[:id])
    @event = Event.new
    @events = Event.all_public(@user)

    events = []
    editable = (@user.id == session[:user_id])
    @events.each do |event|
    puts event.start_date.utc
      events << event.to_timeline(editable)
    end
    @data = {"events" => events}.to_json

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    render :text => "nothing to see here, move along folks"
  end

  def create
    render :text => "nothing to see here, move along folks"
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
   
    all_events = []
    @user.events.each do |event|
        all_events << event.to_timeline
    end
    @user.friends.each do |friend|
      friend.events.each do |event|
        all_events << event.to_timeline
      end
    end

    if friendship.selected
      friend = User.find(friendship.friend_id)
      more_events = Event.all_public(friend)
      more_events.each do |event|
        all_events << event.to_timeline
      end
    end

    @data = {"events" => all_events}.to_json
    render :partial => 'friendships/following'
  end
end
