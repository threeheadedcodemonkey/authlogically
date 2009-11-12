# Remove engine app files from load_once paths so
# they reload on each request during development mode
%w{ controllers helpers models }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

# Remove plugin lib path from load once paths
ActiveSupport::Dependencies.load_once_paths.delete(File.join(File.dirname(__FILE__), 'lib'))

# Register UsersObserver
ActiveRecord::Base.observers << :user_observer
