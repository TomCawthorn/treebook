require 'test_helper'

class UserTest < ActiveSupport::TestCase

	should have_many(:user_friendships)
	should have_many(:friends)
	should have_many(:pending_user_friendships)
	should have_many(:pending_friends)
	should have_many(:requested_user_friendships)
	should have_many(:requested_friends)	

	test "a user should enter a first name" do
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end

	test "a user should enter a last name" do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a unique profile name" do
		user = User.new
		user.profile_name = users(:tom).profile_name
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user can have a correctly formatted profile name" do
		user = User.new( first_name: 'Tom', last_name: 'Cawthorn', email: 'tom@cawthorn2.com' )
		user.password = user.password_confirmation = 'password'
		user.profile_name = 'validname'

		assert user.valid?
	end

	test "a user should have a profile name without spaces" do
		user = User.new( first_name: 'Tom', last_name: 'Cawthorn', email: 'tom@cawthorn2.com' )
		user.password = user.password_confirmation = 'password'		
		user.profile_name = "has spaces"

		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?("Username must be formatted correctly.")
	end

	test "that no error is raised when trying to access a users friends" do
		assert_nothing_raised do
			users(:tom).friends
		end
	end

	test "that creating a friendship on user works" do
		users(:tom).pending_friends << users(:john)
		users(:tom).pending_friends.reload
		assert users(:tom).pending_friends.include?(users(:john))
	end

	test "that calling to_param on a user returns the profile_name" do
		assert_equal "johnman", users(:john).profile_name
	end

end
