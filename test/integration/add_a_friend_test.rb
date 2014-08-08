require 'test_helper'

class AddAFriendTest < ActionDispatch::IntegrationTest
  
  def sign_in_as(user,password)
  	post login_path, user: { email: user.email, password: password }
  end


	test "that adding a friend works" do
		sign_in_as users(:tom), "testing"
		

		get "user_friendships/new?friend_id=#{users(:john).profile_name}"
		assert_response :success

		assert_difference "UserFriendship.count" do
			post "/user_friendships", user_friendship: { friend_id: users(:john).profile_name }
			assert_response :redirect
			assert_equal "You are now friends with #{ users(:john).full_name }", flash[:success]
		end
	end	
end
