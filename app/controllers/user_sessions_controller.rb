class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :except => [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = I18n.t('flash.user_sessions.create.notice')
      redirect_to_back_or_default(root_url)
    else
      flash[:error] = I18n.t('flash.user_sessions.create.error')
      render(:action => 'new', :status => :bad_request)
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = I18n.t('flash.user_sessions.destroy.notice')
    redirect_to_back_or_default(login_url)
  end
end
