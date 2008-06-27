require File.dirname(__FILE__) + '/../test_helper'
require 'visio'
require 'shape_aware_card'

class ShapeAwareCardTest < Test::Unit::TestCase
    include Visio

    def setup
        @visio = connect()
        @doc = open_document(@visio, File.dirname(__FILE__) + '/tmp.vsd')
    end

    def teardown
        close_all_documents(@visio)
    end

    def test_create_shape
        card = Card.new(nil, '5.4.3', 'Foo', 'Winnie finds piglet', Card::TASK, nil)
        card.x, card.y, card.width, card.height = [0, 0, 2, 3]

        shape = card.create_shape(self, @doc.pages(1))
        new_card = Card.new(nil, nil, nil, nil, nil, nil)
        new_card.link_to_shape(shape)

        assert_equal([-0.5, 0, 3, 3], [new_card.x, new_card.y, new_card.width, new_card.height])
        assert_equal("5.4.3\nFoo", shape.shapes(2).text)
        assert_equal("Winnie finds piglet", shape.shapes(1).text)
    end

    def test_shape_wrapper
        shape = ShapeWrapper.new(@doc.pages(1).shapes(1))

        assert_equal("1.0.0", shape.card_id)
        assert_equal("Something really interesting", shape.description_shape.text)
        assert_equal(shape.shape.Id, shape.shape_id)
        assert_in_delta(1640 / 25.4, shape.get_inches('PinX'), 0.001)
    end

    def test_linking_to_shape
        shape = @doc.pages(1).shapes(1)

        card = Card.new(nil, "1.3.4", "name", "des", Card::TASK, nil)
        card.link_to_shape(shape)

        assert_equal(shape.Id, card.shape_id)
        assert_in_delta(1640 / 25.4 - 1, card.x, 0.001)
        assert_in_delta(125 / 25.4 + 0.8, card.y, 0.001)
        assert_equal([2.0, 1.6], [card.width, card.height], 0.001)

        card.x = 2
        card.y = 1
        card.width = 3
        card.height = 7

        card.update_shape(shape)

        assert_equal('3.5 in.', shape.cells("PinX").formula)
        assert_equal('-2.5 in.', shape.cells("PinY").formula)
        assert_equal('3 in.', shape.cells("Width").formula)
        assert_equal('7 in.', shape.cells("Height").formula)
        assert_equal("1.3.4\nname", shape.shapes(2).text)
    end
end