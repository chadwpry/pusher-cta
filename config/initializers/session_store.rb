# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pusher-cta_session',
  :secret      => '8a0d4bc20b27cfdf92206dbc3a9f9dec19105747f7d67da620b1e8ea54d38729159d6efe6f27202a2d17975d108245878004aa749570466ae90b4e506d47ef90'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
