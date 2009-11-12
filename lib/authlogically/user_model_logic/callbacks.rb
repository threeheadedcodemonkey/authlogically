module Authlogically::UserModelLogic::Callbacks
  def self.included(base)
    # WARNING! Do not uncomment the following line! Authlogic sets
    # reset_perishable_token as a before_save callback by default. Calling it
    # here is redundant.
    #
    # Create activation code through Authlogic's reset_perishable_token
    #
    #base.before_create(:reset_perishable_token)
  end
end
