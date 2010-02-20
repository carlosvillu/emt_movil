# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_emt_session',
  :secret      => '9acf4243ec57d722ce1489eaad6c0da6d13969c9c59d0ff5471993e2a91a112de69ca1a70ee21e1cbcfdf0c77771d6a95c603ad7ebd822548da762c0f102d9a4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
