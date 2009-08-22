class SessionsController < ApplicationController

  def new
  end

  def rpx_token
    raise "hackers?" unless data = RPXNow.user_data(params[:token])
    session[:current_user] = User.find_by_identifier(data[:identifier]) || User.create!(data)
    redirect_to '/'
  end

end
