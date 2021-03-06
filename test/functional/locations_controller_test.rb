require 'test_helper'
require 'flexmock/test_unit'

class LocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[address]'
    }
    
    assert_response :success
  end
  
  # TODO: Need to mock auto-geocode in this test
  test "should create location" do
    @request.cookies['http_referer'] = CGI::Cookie.new('http_referer', '/locations')

    assert_difference('Location.count') do
      post :create, :location => {
        :name => 'Onehub',
        :address => '3380 146th Pl SE, Bellevue, WA 98007',
        }
    end
    
    assert_redirected_to "#{locations_path}?location=#{Location.find(:last).id}"
  end
  
  test "should redirect back to new event" do
    @request.cookies['http_referer'] = CGI::Cookie.new('http_referer', '/events/new')
    
    assert_difference('Location.count') do
      post :create, :location => {
        :name => 'Onehub',
        :address => '3380 146th Pl SE, Bellevue, WA 98007'
        }
    end

    assert_redirected_to "/events/new?location=#{Location.find(:last).id}"
  end
  
  test "should redirect back to location show if no http_referer data exists" do
    get :new
    
    post :create, :location => {
      :name => locations(:two).name,
      :address => locations(:two).address
    }
    
    assert_redirected_to location_path(assigns(:location))
  end
  
  # TODO: Need to mock auto-geocode in this test
  test "should not create invalid location" do
    assert_difference('Location.count', 0) do
      post :create, :location => {
        :name => '',
        :address => '3380 146th Pl SE, Bellevue, WA 98007'
        }
    end
    
    assert_not_nil assigns(:location).errors.on(:name)
  end

  test "should show location" do
    get :show, :id => locations(:one).id
    assert_response :success
  end
  
  test "should not show invalid location" do
    get :show, :id => Location.maximum(:id) + 1
  
    assert_response :redirect
    assert flash[:notice]
  end
  
  # TODO: Need to mock Google maps data
  test "map gets location data" do
    get :show, :id => locations(:one).id
    
    assert_response :success
    
    assert_tag :tag => 'div', :attributes => { :id => 'map' }
    assert_match "GLatLng(#{locations(:one).latitude},#{locations(:one).longitude})", @response.body
  end

  test "should get edit" do
    get :edit, :id => locations(:one).id
    
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[address]'
    }

    assert_response :success
  end
  
  test "should not edit invalid location" do
    get :edit, :id => Location.maximum(:id) + 1

    assert_response :redirect
    assert flash[:notice]
  end

  # TODO: Need to mock auto-geocode in this test
  test "should update location" do
    put :update, :id => locations(:one).id, :location => {
      :name => 'Onehubby'
      }
      
    assert_redirected_to location_path(assigns(:location))
    assert_equal 'Onehubby', Location.find(locations(:one).id).name
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, :id => locations(:one).id
    end

    assert_redirected_to locations_path
  end
end
