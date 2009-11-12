module Authlogically::UserModelLogic::Scopes
  def self.included(base)
    base.named_scope(:active, :conditions => {:active => true})
  end
end
