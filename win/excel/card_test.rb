require File.dirname(__FILE__) + '/../test_helper'
require 'card'

class CardTest < Test::Unit::TestCase
    def test_estimate_changes_name
        card = Card.new(nil, 5, 'foo', 'is a card', Card::REQUIREMENT, '5')

        assert_equal('foo (5)', card.name)
    end
end
