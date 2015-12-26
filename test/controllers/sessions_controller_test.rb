require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect to shourt urls page if valid user has logged in" do
    User.stub_any_instance(:authenticate, true) do
      user = users(:one)
      post :create, session: {email: user.email, password: user.password}

      assert_redirected_to short_urls_path
      assert_equal user.id, session[:user_id]
    end
  end

  test "should login if valid user has logged in using json api" do
    User.stub_any_instance(:authenticate, true) do
      user = users(:one)
      post :create, format: :json,session: {email: user.email, password: user.password}

      assert_equal user.id, session[:user_id]
      assert_response 201
    end
  end

  test "should redirect to login page if invalid user tries to login" do
    User.stub_any_instance(:authenticate, false) do
      post :create, session: {email: "invaliduser@gmail.com", password: "invalidpass"}

      assert_equal nil, session[:user_id]
      assert_response :success
    end
  end

  test "should throw 422 if invalid user tries to login" do
    User.stub_any_instance(:authenticate, false) do
      post :create, format: :json, session: {email: "invaliduser@gmail.com", password: "invalidpass"}

      assert_equal nil, session[:user_id]
      assert_response 422
    end
  end

  test "should redirect to root url if user has logged out" do
    User.stub_any_instance(:authenticate, true) do
      user = users(:one)
      post :create, session: {email: user.email, password: user.password}
      assert_equal user.id, session[:user_id]

      delete :destroy
      assert_redirected_to root_url
      assert_equal nil, session[:user_id]
    end
  end

  test "should redirect to root url if user has logged out using json api" do
    User.stub_any_instance(:authenticate, true) do
      user = users(:one)
      post :create, session: {email: user.email, password: user.password}
      assert_equal user.id, session[:user_id]

      delete :destroy, format: :json
      assert_redirected_to root_url
      assert_equal nil, session[:user_id]
    end
  end
end
