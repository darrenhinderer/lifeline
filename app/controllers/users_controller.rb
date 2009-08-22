class UsersController < ApplicationController
  def index
    @users = User.search(params[:query])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(params[:id])
    @events = Event.all
    events = []
    @events.each do |event|
      # dates need to be utc
      tmp = { :start => event.start_date.utc.to_s,
              :title => event.title,
              :description => event.content }
puts event.end_date.nil?
      tmp.update({ :end => event.end_date.utc.to_s}) unless event.end_date.nil?
      events << tmp
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
end
