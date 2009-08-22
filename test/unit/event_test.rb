require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def makeUser(name)
    user = User.new
    user.name = name
    user.username = name
    user.email = name + "@example.com"
    user.identifier = name
    user.save
    return user
  end

  def makeEvent(user, name)
    vent = Event.new
    vent.user_id = user.id
    vent.title = name
    vent.content = name
    vent.start_date = Date.new
    vent.end_date = Date.new
    vent.private = false
    vent.save
    return vent
  end

  def test_truthiness
    bill = makeUser("bill")
    vent = makeEvent(bill, "DOB")
    bob = makeUser("bob")
    vent = makeEvent(bob, "DOB")
    result = Event.all_public(bob)
    assert_not_nil result
    assert_equal 1, result.length
    assert_equal "DOB", result[0].title
    vent = makeEvent(bob, "Grad")
    result = Event.all_public(bob)
    assert_equal 2, result.length
    vent = makeEvent(bob, "Married")
    vent.private = true;
    vent.save
    result = Event.all_public(bob)
    assert_equal 2, result.length
  end
end
