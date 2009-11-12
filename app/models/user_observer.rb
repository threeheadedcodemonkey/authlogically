class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserNotifier.deliver_activation_request(user)
  end

  # NOTE: We're now dealing with this in UserController
  #def after_save(user)
  #  UserNotifier.deliver_signup_notification(user) if user.recently_activated?
  #end
end
