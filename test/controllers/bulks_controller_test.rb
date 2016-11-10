require 'test_helper'

class BulksControllerTest < ActionController::TestCase
  setup do
    @bulk = bulks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bulks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bulk" do
    assert_difference('Bulk.count') do
      post :create, bulk: { email: @bulk.email, name: @bulk.name, telephone: @bulk.telephone }
    end

    assert_redirected_to bulk_path(assigns(:bulk))
  end

  test "should show bulk" do
    get :show, id: @bulk
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bulk
    assert_response :success
  end

  test "should update bulk" do
    patch :update, id: @bulk, bulk: { email: @bulk.email, name: @bulk.name, telephone: @bulk.telephone }
    assert_redirected_to bulk_path(assigns(:bulk))
  end

  test "should destroy bulk" do
    assert_difference('Bulk.count', -1) do
      delete :destroy, id: @bulk
    end

    assert_redirected_to bulks_path
  end
end
