require File.dirname(__FILE__) + "/../lib/cards"

gem "rspec"
gem "file_sandbox"

require 'cards/text_writer'

Spec::Runner.configure do |config|
  #config.mock_with :mocha
end
