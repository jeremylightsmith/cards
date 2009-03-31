$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
gem 'activesupport'
require 'activesupport'

require 'cards/extensions'
require 'cards/csv_parser'

require 'cards/layouts/column_layout'
require 'cards/layouts/row_layout'
require 'cards/layouts/nil_layout'

require 'cards/card'
require 'cards/card_wall'
require 'cards/dot_writer'

# csv builders
require 'cards/csv_builder'
require 'cards/master_story_list'
require 'cards/tracker_csv'

# osx specific - require them explicitly
#require 'cards/numbers_parser'
#require 'cards/writers/graffle_writer'

module Cards
  VERSION = "0.10"
end