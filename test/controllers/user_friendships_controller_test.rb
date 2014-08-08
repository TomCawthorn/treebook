require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

	context "#new" do
		context "when not logged in" do
			should "should redirect to the login page" do
				get :new
				assert_response :redirect
				assert_redirected_to login_path
			end
		end

		context "when logged in" do
			setup do
				sign_in users(:tom)
			end

			should "get new and return success" do
				get :new
				assert_response :success
			end

			should "set a flash error if the friend_id params is missing" do
				get :new, {}
				assert_equal "Friend required", flash[:error]
			end

			should "display the friends name" do
				get :new, friend_id: users(:john)
				assert_match /#{users(:john).full_name}/, response.body
			end

			should "assign a new user friendship" do
				get :new, friend_id: users(:john)
				assert assigns(:user_friendship)
			end

			should "assign a new user friendship to the correct friend" do
				get :new, friend_id: users(:john)
				assert_equal users(:john), assigns(:user_friendship).friend
			end			

			should "assign a new user friendship to logged in suer" do
				get :new, friend_id: users(:john)
				assert_equal users(:tom), assigns(:user_friendship).user
			end

			should "return 404 if the friend can't be found" do
				get :new, friend_id: 'invalid'
				assert_response :not_found
			end

			should "ask if you really want to friend this user" do
				get :new, friend_id: users(:john)
				assert_match /Do you really want to friend #{users(:john).full_name}?/, response.body
			end

		end
	end

	context "#create" do
		context "when not logged in" do
			should "be redirected to the login page" do
				get :new
				assert_response :redirect
				assert_redirected_to login_path
			end
		end

		context "when logged in" do
			setup do
				sign_in users(:tom)
			end

			context "redirected with no friend id" do
				setup do
					post:create
				end

				should "set flash error message" do
					assert !flash[:error].empty?
				end

				should "redirect to the root path" do
					assert_redirected_to root_path
				end
			end

			context "with a valid friend_id" do
				setup do
					post :create, user_friendship: { friend_id: users(:john) }
				end

				should "assign a friend object" do
					assert assigns(:friend)
					assert_equal users(:john).id, assigns(:user_friendship).friend_id
				end

				should "assign a user_friendship object " do
					assert assigns(:user_friendship)
					assert_equal users(:tom), assigns(:user_friendship).user
					assert_equal users(:john), assigns(:user_friendship).friend
				end

				should "create a friendship" do
					assert users(:tom).friends.include?(users(:john))
				end

				should "redirect to the profile page of the friend" do
					assert_response :redirect
					assert_redirected_to profile_path(users(:john))
				end

				should "set the flash success message" do
					assert flash[:success]
					assert_equal "You are now friends with #{users(:john).full_name}", flash[:success]
				end
			end
		end
	end
end
