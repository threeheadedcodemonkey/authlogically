module Authlogically::UserModelLogic::ClassMethods
  # Works just as acts_as_authentic but adds some custom engine-defined configuration.
  #
  # You can pass this a block just like you'd do with acts_as_authentic for extra
  # configuration.
  #
  def acts_as_authentic_with_engine_configuration
    acts_as_authentic do |c|

      # See Authlogically::UserModelLogic::Validations to understand what this does
      #
      add_custom_authlogic_validation_options(c) if include?(Authlogically::UserModelLogic::Validations)

      # Forward the configuration object to the given block (if any) to allow further configuration
      #
      yield(c) if block_given?
    end
  end
end
