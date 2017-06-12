require 'test_helper'

class OauthsControllerTest < ActionController::TestCase
  test "should get callback" do
    get :callback
    assert_response :success
  end

  test "should get failure" do
    get :failure
    assert_response :success
  end

end
