require File.dirname(__FILE__) + '/../test_helper'
require 'authlogic/test_case'

class UserSessionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "route testing" do
    assert_routing 'login', { :controller => "user_sessions", :action => "new" }
    assert_routing 'logout', { :controller => "user_sessions", :action => "destroy" }
  end

  context 'while not logged in' do
    setup do
      @user = not_logged_user(:sheldon)
    end
  
    context "on GET to :new" do
      setup do
        get :new
      end
      should_assign_to :user_session
      should_respond_with :success
      should_render_template :new
      should_not_set_the_flash
    end
      
    context 'on POST to :login with the right password' do
      setup do
        post :create, :user_session => { :login => 'sheldon', :password => 'secret' }
      end
      
      should_assign_to :user_session
      should_set_the_flash_to(/Welcome back!/)
      should_redirect_to('the index page') { root_url }
    end
  
    context 'on POST to :login with the wrong password' do
      setup do
        post :create, :user_session => { :login => 'sheldon', :password => '1234' }
      end
  
      should_assign_to :user_session
      should_respond_with :bad_request
      should_render_template :new
      should_set_the_flash_to(/Invalid username or password./)
      should 'raise an error' do
        assert !assigns(:user_session).errors.nil?
      end
    end
  
    context 'on GET to :logout' do
      setup do
        get :destroy
      end
  
      should_set_the_flash_to(/You must be logged in to access this page/)
      should_redirect_to('the login page') { login_url }
    end
  end
  
  context 'While logged in' do
    setup do
      @user = Factory(:user)
    end
  
    context 'on GET to :destroy' do
      setup do
        get :destroy
      end
  
      should_set_the_flash_to(/Bye!/)
      should_redirect_to('the login page') { login_url }
    end
  
    context 'on GET to :new' do
      setup do
        get :new
      end
  
      should_set_the_flash_to(/You must be logged out to access this page/)
      should_redirect_to('the home page') { root_url }
    end
  end
end
