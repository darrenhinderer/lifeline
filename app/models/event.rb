class Event < ActiveRecord::Base
  before_validation :set_modification
  belongs_to :user
  validates_presence_of :title, :start_date, :modification, :user_id

  def set_modification()
    self.modification = DateTime.now
  end

  def self.all_public(user)
    return find(:all, :conditions => { :user_id => user.id, :private => false }
      :order => :start_date)
  end

  def self.latest()
    now = Time.new.utc
    last = now - 1;
    dtnow = DateTime.parse(now.to_s);
    dtlast = DateTime.parse(last.to_s);
    return find(:all, :conditions => { :private => false, :modification => (dtlast..dtnow)}, :order => :modification)
  end

  def to_timeline(editable=true)
    # dates need to be utc
    tmp_h = { :id => id.to_s, :start => start_date.utc.to_s, :title => title,
      :description => content, :editable => editable }
    tmp_h.update({ :end => end_date.utc.to_s}) unless end_date.nil?
    return tmp_h
  end
end
