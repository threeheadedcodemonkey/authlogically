require 'test_helper'

class StoreLocationTest < ActionController::IntegrationTest
  test "try to logout without being logged in" do
    @user = Factory(:user)

    get '/logout'

    assert_redirected_to login_url
    assert_equal logout_path, session[:return_to]

    follow_redirect!

    post '/user_sessions', :user_session => {:login => @user.login, :password => 'secret'}

    assert_redirected_to logout_path
    assert_nil session[:return_to]
  end
end
