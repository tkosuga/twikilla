# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twikilla_session',
  :secret      => '90f6b61e5ff7dfba9fb240c12098d6ee8b98b04a6aae01b05cbf7478a1c0936159eb7ea440bb2f06b20547a8120626eea65241ba2418aa06b704b2365a792460'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
