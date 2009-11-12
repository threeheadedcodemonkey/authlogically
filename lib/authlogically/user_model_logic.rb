# This module contains all the relevant logic for the User model.
#
# We define it here so that if anyone needs to overwrite the engine-provided
# User model they can still have access to all the engine-defined functionality
# without having to copy it over.
#
module Authlogically::UserModelLogic
  def self.included(base)
    base.class_eval do

      # Include all submodules
      #
      [Validations, Scopes, Callbacks, InstanceMethods].each do |submodule|
        include submodule
      end

      # Class methods must be injected with extend instead of include
      #
      extend ClassMethods

      # acts_as_authentic must be called after the inclusion of other submodules in order
      # to have access to config modifiers (Authlogic configuration can't be modified
      # afterwards).
      #
      # See Authlogically::UserModelLogic::ClassMethods to understand the following call.
      #
      acts_as_authentic_with_engine_configuration
    end
  end
end
