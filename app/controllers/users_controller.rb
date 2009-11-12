class UsersController < ApplicationController
  before_filter :find_user, :only => [:show]

  before_filter :require_user, :except => [:show, :new, :create, :activate]
  before_filter :require_no_user, :only => [:new, :create, :activate]

  # before_filter :require_current_user, :only => [:update, :edit, :destroy]
  before_filter :require_current_user_by_login, :only => [:update, :edit, :destroy]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = I18n.t('flash.users.create.notice')
      redirect_to(root_url)
    else
      flash[:error] = I18n.t('flash.users.create.error')
      render(:action => 'new')
    end
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      flash[:notice] = I18n.t('flash.users.update.notice')
      redirect_to(user_url(current_user))
    else
      flash[:error] = I18n.t('flash.users.update.error')
      render(:action => 'edit')
    end
  end

  def destroy
    current_user.destroy
    flash[:notice] = I18n.t('flash.users.destroy.notice')
    redirect_to(root_url)
  end

  def activate
    if @user = User.find_by_perishable_token(params[:activation_token])
      @user.activate!

      # Log the user in
      UserSession.create(@user)

      # Send welcome e-mail to the user
      #
      # NOTE: We're dealing with this here instead of in
      # UserObserver since calling UserSession.crete saves
      # the user, therefore calling the after_save callback
      # twice (and sending two e-mails)
      #
      UserNotifier.deliver_signup_notification(@user)

      flash[:notice] = I18n.t('flash.users.activate.notice')
      redirect_to(user_url(@user))
    else
      flash[:error] = I18n.t('flash.users.activate.error')
      redirect_to(root_url)
    end
  end

private
  
  def find_user
    @user = User.find_by_login!(params[:id])
  end

  def require_current_user_by_login
    unless current_user.login == params[:id].to_s
      logger.error params.inspect
      flash[:error] = I18n.t('authlogic_users.flash.dont_have_permissions')
      redirect_to(root_url)
      return false
    end
  end
end
