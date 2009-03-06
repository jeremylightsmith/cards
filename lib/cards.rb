$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# this is making this a mac only distro, I'm afraid
require 'rubygems'
gem 'rb-appscript'
require 'appscript'

require 'cards/extensions'
require 'cards/builder'
require 'cards/csv_parser'
require 'cards/numbers_parser'

require 'cards/card_wall'
# writers
require 'cards/writers/dot_writer'
require 'cards/writers/graffle_writer'

# csv builders
require 'cards/csv_builder'
require 'cards/master_story_list'
require 'cards/tracker_csv'

module Cards
  VERSION = "0.9.1"
end