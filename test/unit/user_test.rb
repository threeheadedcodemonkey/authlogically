require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = Factory(:sheldon)
  end
  should_validate_uniqueness_of :login, :email

  should_validate_presence_of :name

  #should_protect_attribute :password

  should_not_allow_values_for :login, "John Doe", "John@Doe", "John%Doe", "John&Doe", "jd", "j", ""
  should_allow_values_for     :login, "JohnDoe", "johndoe", "jOhN_dOe-123", "jxd", "123-_-_"

  should_not_allow_values_for :email, "blah", "b lah", "bla h@blo", "bla@blo", "bla h@blo.com", "bla@blo h.com"
  should_allow_values_for     :email, "a@a.com", "asdf@asdf.com", "john.doe@mail.com", "john.doe+blo@gmail.com"

  context 'on build' do
    setup do
      @user = Factory(:inactive_user)
    end

    should 'not be active' do
      assert !@user.active?
    end

    should 'be at its first login' do
      assert @user.first_login?
    end

    should 'not be recently activated' do
      assert !@user.recently_activated?
    end
  end

  context 'on create' do
    setup do
      @user = Factory.create(:inactive_user)
    end

    should 'not be active' do
      assert !@user.active?
    end

    should 'not be recently activated' do
      assert !@user.recently_activated?
    end

    should 'set a perishable token' do
      assert_not_nil @user.perishable_token
    end

    should 'not be findable using the active scope' do
      assert_raise ActiveRecord::RecordNotFound do
        User.active.find(@user.id)
      end
    end

    context 'after activation' do
      setup do
        @old_perishable_token = @user.perishable_token

        @activation_result = @user.activate!
      end

      should 'be successful' do
        assert @activation_result
      end

      should 'become active' do
        assert @user.active?
      end
      
      should 'change the perishable token' do
        assert_not_equal @old_perishable_token, @user.perishable_token
      end

      should 'be saved' do
        assert !@user.changed?
      end

      should 'be recently activated' do
        assert @user.recently_activated?
      end

      should 'not findable using the active scope' do
        assert_equal @user, User.active.find(@user.id)
      end
    end
  end

  context 'always' do
    setup do
      @user = Factory(:user)
    end

    should 'match login with to_param' do
      assert_equal @user.login, @user.to_param
      assert_kind_of String, @user.to_param
    end

=begin
    should 'not allow the login (username) to change' do
      assert_equal 'joe', @user.login

      begin
        @user.update_attributes({ :login => 'schmoe' })
        assert false
      rescue
        assert true
      end

      assert_equal 'joe', @user.login
    end
=end
  end
end
