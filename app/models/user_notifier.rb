class UserNotifier < ActionMailer::Base
  def activation_request(user)
    setup_for user
    subject   "Activate your account"
  end

  def signup_notification(user)
    setup_for user
    subject   "Account activated!"
  end

private
  
  def setup_for(user)
    from       ENV['USER_NOTIFIER_FROM'] || 'noreply@example.com'
    recipients user.email
    body       :user => user
  end
end
