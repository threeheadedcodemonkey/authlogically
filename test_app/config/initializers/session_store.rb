# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test_app_session',
  :secret      => 'd8c8b9c151d71890f80f48fcfbb1b9ad9aaccc74fa8e2aa25a091352309e3bc103cdc0acf5955aa21099b2821a6d11d786676ac11a170cfba7caf8be04ea75a0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
