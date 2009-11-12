# Authlogic comes with some own validations for the login and email fields,
# and the defaults are for the most part sensible, so we don't need to add
# much else here with regard to those fields.
#
# We still need to validate other custom fields we added (such as name)
# and make some adjustments to Authlogic's validations to make sure they
# play nice with other features in this engine (such as login-based URLs).
#
module Authlogically::UserModelLogic::Validations

  # Custom format regex for logins (spaces and @ are not allowed)
  #
  VALID_LOGIN = /\A[a-z0-9_-]+\Z/i.freeze

  def self.included(base)
    # Add custom validations
    #
    base.validates_presence_of(:name)

    base.extend(ClassMethods)
  end

  module ClassMethods

    # Since Authlogic validation options need to be passed in the acts_as_authentic block
    # we can't use the self.included trick above, so for code concern separation's sake we
    # define this method here to call inside the acts_as_authentic block.
    #
    def add_custom_authlogic_validation_options(authlogic_configuration)

      # Replace Authlogic's default login format regex to disallow URL-unfriendly characters
      #
      authlogic_configuration.validates_format_of_login_field_options(
        :with    => Authlogically::UserModelLogic::Validations::VALID_LOGIN,
        :message => Authlogic::I18n.t('error_messages.login_invalid', :default => "should use only letters, numbers, dashes (-) and underscores (_) please.")
      )

    end

  end
end
