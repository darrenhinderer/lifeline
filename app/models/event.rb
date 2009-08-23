class Event < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :start_date, :user_id

  def self.all_public(user)
    return find(:all, :conditions => { :user_id => user.id, :private => false }, 
      :order => :start_date)
  end

  def to_timeline(editable=true)
    # dates need to be utc
    tmp_h = { :id => id.to_s, :start => start_date.utc.to_s, :title => title,
      :description => content, :editable => editable }
    tmp_h.update({ :end => end_date.utc.to_s}) unless end_date.nil?
    return tmp_h
  end
end
