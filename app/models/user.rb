class User < ActiveRecord::Base
  validates_presence_of :username
  validates_presence_of :name
  validates_presence_of :email
  has_many :events
  is_gravtastic!

  def self.search query
    if query && query.size > 0
      User.find(:all, :conditions => ["username like ? or email like ?", 
        "%#{query}%", "%#{query}"])
    else
      User.all
    end
  end
end
