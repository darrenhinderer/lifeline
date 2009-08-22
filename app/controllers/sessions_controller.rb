class SessionsController < ApplicationController
  before_filter :login_required, :only =>['foo']

  def new
  end

  def rpx_token
    raise "hackers?" unless data = RPXNow.user_data(params[:token])
    user = User.find_by_identifier(data[:identifier]) || User.create!(data)
    session[:user_id] = user.id
    redirect_to '/'
  end

  def destroy
    session[:user_id] = nil
    redirect_to :controller => "sessions", :action => "new"
  end

  def foo
    @user = User.find(session[:user_id])
  end

end
