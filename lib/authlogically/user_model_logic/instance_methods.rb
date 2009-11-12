module Authlogically::UserModelLogic::InstanceMethods

  # By default use #login in URLs instad of #id so we can get URLs like:
  #
  #   /users/johndoe
  #
  # instead of:
  #
  #   /users/1
  #
  # We limit login names to only letters, numbers, dashes and underscores,
  # so this shouldn't be a problem.
  #
  def to_param
    login
  end

  # Returns whether the user is logging in for the first time.
  #
  # Useful to have to display first-time welcome messages or such.
  #
  def first_login?
    last_login_at.nil?
  end

  # Activates the user account.
  #
  # The perishable token is also reset.
  #
  def activate!
    @activated = true

    self.active = true
    
    # Authlogic resets the perishable token by default on save, but I'm leaving the call
    # to reset_perishable_token! here directly to help reveal intent (which's is kinda a
    # dead purpose after this long comment, but who cares).
    #
    # This also saves the record.
    #
    reset_perishable_token!
  end

  # Returns true if the user was activated in this instance.
  #
  def recently_activated?
    @activated
  end
end
