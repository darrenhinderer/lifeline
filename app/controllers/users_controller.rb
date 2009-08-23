class UsersController < ApplicationController

  def index
    @latest = Event.init_latest()
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def search
    @users = User.search(params[:query], params[:page])
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(params[:id])
    @event = Event.new(:start_date => Date.today)
    respond_to do |format|
      format.html # show.html.erb
      format.json {
        data = {"events" => @user.collect_events}
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

end
