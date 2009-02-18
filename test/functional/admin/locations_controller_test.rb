require 'test_helper'

class Admin::LocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create locations" do
    assert_difference('Admin::Locations.count') do
      post :create, :locations => { }
    end

    assert_redirected_to locations_path(assigns(:locations))
  end

  test "should show locations" do
    get :show, :id => admin_locations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_locations(:one).id
    assert_response :success
  end

  test "should update locations" do
    put :update, :id => admin_locations(:one).id, :locations => { }
    assert_redirected_to locations_path(assigns(:locations))
  end

  test "should destroy locations" do
    assert_difference('Admin::Locations.count', -1) do
      delete :destroy, :id => admin_locations(:one).id
    end

    assert_redirected_to admin_locations_path
  end
end
