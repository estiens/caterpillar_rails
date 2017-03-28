# config/initializers/secret_token.rb
YourApp::Application.config.secret_key_base = ENV['RAILS_SECRET_KEY_BASE']
