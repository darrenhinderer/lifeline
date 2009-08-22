# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_timeline_session',
  :secret      => 'af55ae631fed7691ae747c37d675fce673bf31704e421f8e12d5448638a4a5993a819c8f3486af9fb0df2f8589a1d5a1378d710156f3bb9f9d2694b6bc9d1ead'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
