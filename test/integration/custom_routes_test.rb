require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest

	test "that /login route opens the login path" do
		get '/login'
		assert_response :success
	end

	test "that /register route opens the login path" do
		get '/register'
		assert_response :success
	end

	test "that /logout route opens the login path" do
		get '/logout'
		assert_response :redirect
		assert_redirected_to root_path
	end

end
