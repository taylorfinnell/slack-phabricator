$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'bundler'
Bundler.require :default

require 'app'

run App


