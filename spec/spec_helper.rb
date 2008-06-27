$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")

require "rubygems"
gem "rspec"
gem "mocha"
gem "file_sandbox"

require 'cards/extensions'
require 'cards/writers/text_writer'

Spec::Runner.configure do |config|
  #config.mock_with :mocha
end
