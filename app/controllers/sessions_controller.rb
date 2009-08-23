class SessionsController < ApplicationController
  before_filter :login_required, :only =>['foo']

  def new
    @latest = Event.init_latest()
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def rpx_token
    raise "hackers?" unless data = RPXNow.user_data(params[:token])
    user = User.find_or_create_with_rpx(data)
    session[:user_id] = user.id
    redirect_to user_path(user)
  end

  def destroy
    session[:user_id] = nil
    redirect_to :controller => "sessions", :action => "new"
  end

  def foo
    @user = User.find(session[:user_id])
  end

end
