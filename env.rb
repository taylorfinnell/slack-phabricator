require 'bundler'
require 'json'

Bundler.require :default
Dotenv.load

# configure phabulous for this phabricator instance
Phabulous.configure do |config|
  config.host = ENV['PHABRICATOR_HOST']
  config.user = ENV['PHABRICATOR_USER']
  config.cert = ENV['PHABRICATOR_CERT']
end

# connect to phabricator
Phabulous.connect!
