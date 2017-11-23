require 'test_helper'

class ApplicantsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
