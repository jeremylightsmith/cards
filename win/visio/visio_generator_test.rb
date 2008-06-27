require File.dirname(__FILE__) + '/../test_helper'
require 'visio_generator'
require 'requirements_map'
require 'default_card_layout'

class VisioGeneratorTest < Test::Unit::TestCase
    include Visio

    def setup
        @visio = connect()
    end

    def teardown
        close_all_documents(@visio)
    end

    def test_creating_visio_doc
        map = RequirementsMap.new
        map.add('1.0.0', 'clean', '', Card::ACTIVITY, nil).
            add('1.1.0', 'room', '', Card::TASK, nil).
            add('1.1.1', 'make the bed', '', Card::REQUIREMENT, nil)

        # generate
        generator = VisioGenerator.new
        generator.create(map, File.dirname(__FILE__) + '/visio_generator_test.vsd', DefaultCardLayout.new)

        # test that it actually created something
        doc = @visio.activeDocument
        shape = ShapeWrapper.new(doc.pages(1).shapes(1))

        assert_in_delta(1.16, shape.get_inches("PinX"), 0.001)
        assert_in_delta(4.56, shape.get_inches("PinY"), 0.001)
        assert_equal("1.0.0\nclean", shape.id_name_shape.text)

        shape = ShapeWrapper.new(doc.pages(1).shapes(2))
        assert_in_delta(2.76, shape.get_inches("PinY"), 0.001)
        assert_equal("1.1.0\nroom", shape.id_name_shape.text)
    end
end
