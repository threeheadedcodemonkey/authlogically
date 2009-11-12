module Authlogically::ControllerLogic
  def self.included(base)
    base.filter_parameter_logging(:password)

    base.helper_method(:current_user, :logged_in?)

    base.send(:include, InstanceMethods)
  end
end
