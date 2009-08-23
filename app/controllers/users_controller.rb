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

    respond_to do |format|
      format.html # show.html.erb
      format.json {
        events = []
        editable = (@user.id == session[:user_id])
        @events = Event.all_public(@user)
        @events.each do |event|
          events << event.to_timeline(editable)
        end
        data = {"events" => events }
        render :json => data.to_json
      }
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
end
