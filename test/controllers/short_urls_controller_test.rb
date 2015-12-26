require 'test_helper'
require_relative '../../app/helpers/sessions_helper'

class ShortUrlsControllerTest < ActionController::TestCase
  class LoginTest < ShortUrlsControllerTest
  setup do
    @short_url = short_urls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:short_urls)
  end

  test "should get short urls for a given logged in user only" do
    ShortUrl.create!(original_url: "http://user1.com", user_id: users(:one).id)
    ShortUrl.create!(original_url: "http://user2.com", user_id: users(:two).id)

    get :index

    assert_response :success
    assert_equal ShortUrl.where(user_id: users(:two).id).pluck(:id),assigns(:short_urls).pluck(:id)
    assert_not_includes assigns(:short_urls).pluck(:id), ShortUrl.where(user_id: users(:one).id).pluck(:id)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show short_url" do
    get :show, id: @short_url
    assert_response :success
  end

  test "should create short_url" do
    ShortUrl.destroy_all
    assert_difference('ShortUrl.count') do
      post :create, short_url: {original_url: "http://helloworld.com"}
    end
  end

  test "should destroy short_url" do
    assert_difference('ShortUrl.count', -1) do
      delete :destroy, id: @short_url
    end

    assert_redirected_to short_urls_path
  end
  end

  class LoginApiTest < ShortUrlsControllerTest
    setup do
      @short_url = short_urls(:one)
    end

    test "should get index using api json" do
      get :index, format: :json
      assert_response :success
      assert_not_nil assigns(:short_urls)
    end

    test "should show short_url using api json" do
      get :show,format: :json, id: @short_url
      assert_response :success
    end

    test "should create short_url using api json" do
      ShortUrl.destroy_all
      assert_difference('ShortUrl.count') do
        post :create, format: :json, short_url: {original_url: "http://helloworld.com"}
      end

      assert_response :success
    end

    test "should destroy short_url using json api" do
      assert_difference('ShortUrl.count', -1) do
        delete :destroy,format: :json, id: @short_url
      end

      assert_response :success
    end
  end

  class AuthorizationLoginTest < ShortUrlsControllerTest
    setup do
      @short_url = short_urls(:one)
      User.destroy_all
      @user = User.create!(email: "validuser@gmail.com", name: "valid user", password: "validuser")
      @request.headers['Authorization'] = @user.api_token
    end

    test "should check index using authorization headers" do
      get :index
      assert_equal request.headers["Authorization"], @user.api_token
      assert_response :success
      assert_not_nil assigns(:short_urls)
    end

    test "should create short_url" do
      ShortUrl.destroy_all
      assert_difference('ShortUrl.count') do
        post :create, short_url: {original_url: "http://helloworld.com"}
      end
    end

    test "should destroy short_url" do
      assert_difference('ShortUrl.count', -1) do
        delete :destroy, id: @short_url
      end

      assert_redirected_to short_urls_path
    end
  end
end
