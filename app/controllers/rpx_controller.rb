# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class RpxController < ApplicationController

  def rpx_token
    raise "hackers?" unless data = RPXNow.user_data(params[:token])
   # self.current_user = User.find_by_identifier(data[:identifier]) || User.create!(data)
    puts data.to_yaml
    redirect_to '/'
  end

end
