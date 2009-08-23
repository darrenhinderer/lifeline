class Event < ActiveRecord::Base
  before_validation :set_modification
  belongs_to :user
  validates_presence_of :title, :start_date, :modification, :user_id

  def set_modification()
    self.modification = DateTime.now
  end

  def self.all_public(user)
    return find(:all, :conditions => { :user_id => user.id, :private => false },
      :order => :start_date)
  end

  def self.init_latest
    results = Event.latest(1)
    if (results.length > 0)
      return results
    end
    results = Event.latest(60*60)
    if (results.length > 0)
      return results
    end
    results = Event.latest(60*60*24)
    if (results.length > 0)
      return results
    end
    results = Event.latest(60*60*24*7)
    if (results.length > 0)
      return results
    end
    results = Event.latest(60*60*24*31)
    if (results.length > 0)
      return results
    end
    return results
  end

  def self.latest(seconds)
    now = Time.new.utc
    last = now - seconds;
    dtnow = DateTime.parse(now.to_s);
    dtlast = DateTime.parse(last.to_s);
    puts '*** now: ' + now.to_s
    puts '*** last: ' + last.to_s
    results = find(:all, :conditions => { :private => false,
      :modification => (dtlast..dtnow)}, :order => :modification)
    puts '**** results.length=' + results.length.to_s
    if (results.length > 30)
      return results[0,30]
    end
    return results
  end

  def to_timeline(editable=true)
    # dates need to be utc
    tmp_h = { :id => id.to_s, :start => start_date.utc.to_s, :title => title,
      :description => content, :editable => editable }
    tmp_h.update({ :end => end_date.utc.to_s}) unless end_date.nil?
    return tmp_h
  end
end
