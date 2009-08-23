require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should show users" do
    get :show, :id => users(:darren).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => users(:darren).to_param
    assert_response :success
  end

  test "should update users" do
    put :update, :id => users(:darren).to_param, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end
end
