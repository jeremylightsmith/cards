require File.dirname(__FILE__) + '/../test_helper'
require 'rectangle'

class RectangleTest < Test::Unit::TestCase
    def test_intersect
        a = Rectangle.new(0, 0, 2, 2)
        b = Rectangle.new(1, 1, 3, 1)
        c = Rectangle.new(3, 2, 1, 1)

        assert(a.intersects(b))
        assert(b.intersects(a))
        assert(!a.intersects(c))
    end
end