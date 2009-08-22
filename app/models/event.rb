class Event < ActiveRecord::Base
  belongs_to :user

  def self.getAllPublic(user)
    return find(:all, :conditions => { :user_id => user.id, :private => false })
  end
end
