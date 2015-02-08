$LOAD_PATH.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '..'))

require 'bundler'
Bundler.require :default, :test

require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

require 'app'

