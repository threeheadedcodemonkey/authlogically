ActionController::Routing::Routes.draw do |map|
  # Login and logout
  #
  map.with_options(:controller => 'user_sessions') do |session|
    session.login  'login',  :action => 'new'
    session.logout 'logout', :action => 'destroy'
  end

  map.signup 'signup', :controller => 'users', :action => 'new'

  # Users
  #
  # We add check regexp to make sure we match URLs with proper login names
  #
  map.resources :users, :requirements => {:id => /[0-9a-z_-]+/i}

  # User Account Activation path
  #
  map.user_activation 'activate/:activation_token', :controller => 'users', :action => 'activate', :requirements => {:activation_token => /[0-9a-z_-]+/i}

  map.resources :user_sessions, :only => [:new, :create, :destroy]
end
