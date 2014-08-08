require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

	test "that creating a friendship works" do
		assert_nothing_raised do
			UserFriendship.create user: users(:tom), friend: users(:john)
		end
	end 


	test "that creating a friendship based on user id and friend if works" do
		UserFriendship.create user_id: users(:tom).id, friend_id: users(:john).id
		assert users(:tom).friends.include?(users(:john))
	end 
end
