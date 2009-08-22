require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create users" do
    post :create, :users => { }
    assert_response :success
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

  test "should destroy users" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:darren).to_param
    end

    assert_redirected_to users_path
  end
end
