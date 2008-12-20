require 'test_helper'

class DeelnemersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:deelnemers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deelnemer" do
    assert_difference('Deelnemer.count') do
      post :create, :deelnemer => { }
    end

    assert_redirected_to deelnemer_path(assigns(:deelnemer))
  end

  test "should show deelnemer" do
    get :show, :id => deelnemers(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => deelnemers(:one).id
    assert_response :success
  end

  test "should update deelnemer" do
    put :update, :id => deelnemers(:one).id, :deelnemer => { }
    assert_redirected_to deelnemer_path(assigns(:deelnemer))
  end

  test "should destroy deelnemer" do
    assert_difference('Deelnemer.count', -1) do
      delete :destroy, :id => deelnemers(:one).id
    end

    assert_redirected_to deelnemers_path
  end
end
