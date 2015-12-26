require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create a valid user and redirect to show all short urls" do
    User.destroy_all
    assert_difference('User.count') do
         post :create, user: { email: "user1@gmail.com", name: "user1", password: "hellouser1"}
    end

    assert_redirected_to short_urls_path
  end

  test "should create user using a json api" do
    User.destroy_all
    assert_difference('User.count') do
      post :create, format: :json, user: { email: "user1@gmail.com", name: "user1", password: "hellouser1"}
    end

    assert_response :success
  end

  test "should render new page if invalid user tries to sign up" do
    User.destroy_all
    post :create, user: { email: "invaliduser1@gmail.com", name: "user1", password: "hi"}

    assert_response 200
  end

  test "should render new page if invalid user tries to sign up using json api" do
    User.destroy_all
    post :create, format: :json, user: { email: "invaliduser1@gmail.com", name: "user1", password: "hi"}

    assert_response 422
  end
end
