module Authlogically::ControllerLogic::InstanceMethods
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= (current_user_session && current_user_session.record)
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless current_user
      store_location
      flash[:error] = I18n.t('authlogic_users.flash.must_be_logged_in')
      redirect_to(login_url)
      return false
    end
  end

  def require_current_user
    unless current_user.id == params[:id].to_i
      flash[:error] = I18n.t('authlogic_users.flash.dont_have_permissions')
      redirect_to(root_url)
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:error] = I18n.t('authlogic_users.flash.must_be_logged_out')
      redirect_to(root_url)
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_to_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
