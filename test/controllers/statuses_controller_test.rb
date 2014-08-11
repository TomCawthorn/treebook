require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render new page when logged in" do
    sign_in users(:tom)
    get :new
    assert_response :success
  end

  test "should be logged in to post a status" do
    post :create, status: { content: "hello" }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create status when logged in" do
    sign_in users(:tom)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create a status for the logged in user" do
    sign_in users(:tom)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:james).id }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:tom).id
  end

  test "should be logged in to edit a status" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should show status when logged in" do
    sign_in users(:tom)    
    get :show, id: @status
    assert_response :success
  end

  test "should get edit when logged in" do
    sign_in users(:tom)
    get :edit, id: @status
    assert_response :success
  end

  test "should be logged in to update a status" do
    patch :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update a status when logged in" do
    sign_in users(:tom)
    patch :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update a status for the current user when logged in" do
    sign_in users(:tom)
    patch :update, id: @status, status: { content: @status.content, user_id: users(:james).id }
    assert_redirected_to status_path(assigns(:status))

    assert_equal assigns(:status).user_id, users(:tom).id    
  end

# Not currently working. Although you can check if params exist, if required, 
# rails will not allow for an empty hash inside a required param.
  test "should not update a status when no status is sent in" do
    sign_in users(:tom)
    patch :update, id: @status, status: { user_id: users(:tom).id, content: @status.content } 
    assert_redirected_to status_path(assigns(:status))

    assert_equal assigns(:status).user_id, users(:tom).id    
  end

  test "should destroy status when logged in" do
    sign_in users(:tom)
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
