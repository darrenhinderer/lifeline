class User < ActiveRecord::Base
  #can't rely on rpx to give more than this
  validates_presence_of :identifier

  has_many :events
  has_many :friendships
  has_many :friends, :through => :friendships
  is_gravtastic!

  def self.search query
    if query && query.size > 0
      User.find(:all, :conditions => ["username like ? or email like ?", 
        "%#{query}%", "%#{query}"])
    else
      User.all
    end
  end

  def self.find_or_create_with_rpx(data)
    user = self.find_by_identifier(data[:identifier])
    if user.nil?
      user = self.new
      user.identifier = data[:identifier]
      user.username = data[:preferredUsername]  || data[:username]
      user.email = data[:verifiedEmail] || data[:email]
      user.name = data[:displayName]
      user.save!
    end

    user
  end

  def is_friend? friend
    if self.friends(true).include?(friend)
      return true
    else
      return false
    end
  end

end
