require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, id: users(:tom).profile_name
    assert_response :success
    assert_template 'profiles/show'
  end

  test "should render a 404 on profile not found" do
  	get :show, id: "not found"
  	assert_response :not_found
  end

  test "that variables are assigned on successful profile viewing" do
	get :show, id: users(:tom).profile_name
	assert assigns(:user)
	assert_not_empty assigns(:statuses)
  end

  test "only the correct statuses are shown on a user" do
  	get :show, id: users(:tom).profile_name
  	assigns(:statuses).each do |status|
  		assert_equal users(:tom), status.user
  	end
  end
end
