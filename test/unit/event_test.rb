require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "event validates presence of group" do
    event = Event.new
    assert ! event.valid?
    assert event.errors.on(:group_id)
  end
  
  test "event validates presence of location" do
    event = Event.new
    assert ! event.valid?
    assert event.errors.on(:location_id)
  end
  
  test "event validates presence of start_time" do
    event = Event.new
    assert ! event.valid?
    assert event.errors.on(:start_time)
  end
  
  test "event validates presence of end_time" do
    event = Event.new
    assert ! event.valid?
    assert event.errors.on(:end_time)
  end
  
  # Obsolete now that upcoming is mandatory
  # test "sorts fields correctly" do    
  #   actual = Event.sort(1, 'start_time', 'false')
  #   
  #   expected = [
  #     events(:one),
  #     events(:two),
  #     events(:three),
  #     events(:five),
  #     events(:four)
  #   ]
  #   
  #   assert_equal expected, actual
  # end
  # 
  # test "sorts related fields correctly" do    
  #   actual = Event.sort(1, 'groups.name', 'false')
  #   
  #   expected = [
  #     events(:three),
  #     events(:two),
  #     events(:four),
  #     events(:five),
  #     events(:one)
  #   ]
  #   
  #   assert_equal expected, actual
  # end
  
  test "sorts fields hides past events" do    
    actual = Event.sort(1, 'start_time')
    
    expected = [
      events(:three),
      events(:five),
      events(:four)
    ]
    
    assert_equal expected, actual
  end
  
  test "sorts upcoming local events" do
    lat = (locations(:three).latitude + locations(:five).latitude) / 2
    lon = (locations(:three).longitude + locations(:five).longitude) / 2
    
    actual = Event.sort(1, 'start_time', 'true', { :latitude => lat, :longitude => lon })
    
    expected = [
      events(:three),
      events(:five)
    ]
    
    assert_equal expected, actual
  end

  test "date should be formatted properly" do
    assert_equal "February 24, 2009", Event.pretty_date(Time.parse('2009-02-24 06:45pm'))
  end
    
  test "time should be formatted properly" do
    assert_equal "06:45 - 07:45 PM", Event.pretty_time(Time.parse('2009-02-24 06:45pm'), Time.parse('2009-02-24 07:45pm'))
  end
end
