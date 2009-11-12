# Barebones Authlogic User model
class User < ActiveRecord::Base
  include Authlogically::UserModelLogic

  # Delete the above line and uncomment the following if
  # you wish some more fine-grained feature inclusion
  #authlogic_user
end
