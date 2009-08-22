class SessionsController < ApplicationController

  def new
  end

  def rpx_token
    raise "hackers?" unless data = RPXNow.user_data(params[:token])
    self.current_user = User.find_by_identifier(data[:identifier]) || User.create!(data)
    puts data.to_yaml
    redirect_to '/'
  end

end
