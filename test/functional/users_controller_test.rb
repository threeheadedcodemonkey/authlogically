require File.dirname(__FILE__) + '/../test_helper'
require 'authlogic/test_case'

class UsersControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  # REST Routes
  should_route :get, '/users', :action => :index
  should_route :post, '/users', :action => :create
  should_route :get, '/users/1', :action => :show, :id => '1'
  should_route :get, '/users/1/edit', :action => :edit, :id => '1'
  should_route :put, '/users/1', :action => :update, :id => '1'

  context "While not logged in" do
    setup do
      @not_logged_user = not_logged_user(:sheldon)
    end
    context "doing GET to :new" do
      setup do
        get :new
      end
      should_assign_to :user
      should_render_template :new
    end
  
    context "doing POST to :create" do
      setup do
        post :create, :user => { :name => "Howard Wolowitz", :login => "wolowizard", :email => "wolowizard@bbt.com", :password => "secret", :password_confirmation => "secret"}
      end
      should_assign_to :user
      should_set_the_flash_to(/Your account was created successfully. We've sent you an e-mail with instructions for activating it./)
      should_redirect_to("the home page"){ root_url }
      should "create the user" do
        assert_not_nil User.find_by_login("wolowizard")
      end
      should "not be active" do
        assert_equal false, User.find_by_login("wolowizard").active
      end
    end
  
    context "doing GET to :edit" do
      setup do
        get :edit, :id => @not_logged_user.to_param
      end
      should_set_the_flash_to(/You must be logged in to access this page/)
      should_redirect_to("the login"){ login_url }
    end
  
    context "doing PUT to :update" do
      setup do
        put :update, :id => @not_logged_user.to_param, :user => { :name => "Modified" }
      end
      should_set_the_flash_to(/You must be logged in to access this page/)
      should_redirect_to("the login"){ login_url }
    end
    
    context "doing POST to :activate" do
      setup do
        @user = Factory(:leonard_not_active)
        post :activate, :activation_token => @user.perishable_token
      end
      should_set_the_flash_to(/Welcome! Your account has now been activated./)
      should_redirect_to("the home page"){ user_url(@user) }
    end

    context "doing POST to :activate with incorrect data" do
      setup do
        post :activate, :activation_token => "blo"
      end
      should_set_the_flash_to(/Invalid activation code./)
      should_redirect_to("the home page"){ root_url }
    end
  end

  context "While logged in" do
    setup do
      @sheldon = not_logged_user(:sheldon)
      @logged_user = Factory(:user)
    end
    
    context "doing GET to :edit" do
      setup do
        get :edit, :id => @logged_user.to_param
      end
      should_render_template :edit
      should_not_set_the_flash
    end
    
    context "doing GET to :edit with some other's id" do
      setup do
        get :edit, :id => @sheldon.to_param
      end
      should_set_the_flash_to(/You don't have permissions to see this page./)
      should_redirect_to('the home page'){ root_url }
    end
  
    context "doing GET to :new" do
      setup do
        get :new
      end
      should_set_the_flash_to(/You must be logged out to access this page/)
      should_redirect_to("the home page"){ root_url }
    end
  
    context "doing POST to :create" do
      setup do
        post :create, :user => { :name => "Howard Wolowitz", :login => "wolowizard", :password => "secret", :password_confirmation => "secret", :email => "wolowizard@bbt.com"}
      end
      should_set_the_flash_to(/You must be logged out to access this page/)
      should_redirect_to("the home page"){ root_url }
    end
  
    context "doing PUT to :update" do
      setup do
        put :update, :id => @logged_user.to_param, :user => { :name => "Modified" }
      end
      should_set_the_flash_to(/Your account was updated successfully./)
      should_redirect_to('the user page'){ user_path(@logged_user) }
      should "update the user" do
        assert_equal "Modified", @logged_user.reload.name 
      end
    end
  
    context "doing PUT to :update with other's id" do
      setup do
        put :update, :id => @sheldon.to_param, :user => { :name => "Modified" }
      end
      should_set_the_flash_to(/You don't have permissions to see this page./)
      should_redirect_to('the home page'){ root_url }    
    end
  end
end
