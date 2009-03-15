require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # TODO: Need to mock auto-geocode in this test
  test "location validates presence of name" do
    location = Location.new
    location.address = locations(:one).address
    
    assert ! location.valid?
    assert location.errors.on(:name)
    
    # TODO: This is an order of operations thing - in the background, the app/gem try to handle the address/geocoding data first.  If the form has an address entered, then it errors properly.
  end
  
  test "location validates presence of address" do
    location = Location.new
    assert ! location.valid?
    assert location.errors.on(:address)
  end
  
  # TODO: Need to mock auto-geocode in this test
  test "should auto-geocode address" do
    location = Location.create(:name => locations(:one).name, :address => locations(:one).address)
    assert location.valid?
    
    assert_equal 47.5798527, location.latitude
    assert_equal -122.1456091, location.longitude
  end
end
