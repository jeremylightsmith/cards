require 'card'
require 'visio'

class Card
    ART_SHAPES = 'Art Shapes.vss'
    DISPLAY_ID = true

    attr_reader :shape_id

    def pin_x() @x + @width / 2.0 end
    def pin_y() @y - @height / 2.0 end

    def link_to_shape(shape)
        shape = ShapeWrapper.new(shape)
        @shape_id = shape.shape_id

        @width = shape.get_inches('Width')
        @height = shape.get_inches('Height')
        @x = shape.get_inches('PinX') - width / 2.0
        @y = shape.get_inches('PinY') + height / 2.0

        @has_been_positioned = true
    end

    def update_shape(shape)
        shape = ShapeWrapper.new(shape)
        update_shape_data(shape)
        update_shape_position(shape)
    end

    def create_shape(visio, page)
        shape = visio.drop_master_on_page(page, type, ART_SHAPES, pin_x, pin_y)
        @shape_id = shape.Id

        update_shape_data(ShapeWrapper.new(shape))

        shape
    end

    private

    def update_shape_data(shape)
        shape.id_name_shape.text = DISPLAY_ID ? "#{id}\n#{name}" : name
        shape.description_shape.text = "#{description}"
    end

    def update_shape_position(shape)
        shape.set_inches('PinX', pin_x)
        shape.set_inches('PinY', pin_y)
        shape.set_inches('Width', width)
        shape.set_inches('Height', height)
    end
end

class ShapeWrapper
    attr_reader :shape

    def initialize(shape)
        @shape = shape
    end

    def shape_id
        @shape.Id
    end

    def represents_a_card?
        (id_name_shape.text =~ /^(\d+\.\d+\.\d+)\n./) != nil
    end

    def card_id
        if id_name_shape().text =~ /^(\d+\.\d+\.\d+)/
            $1
        else
            raise "couldn't parse #{id_name_shape.text}"
        end
    end

    def id_name_shape
        @shape.shapes(2)
    end

    def description_shape
        @shape.shapes(1)
    end

    def get_inches(name)
        s = @shape.cells(name).formula
        if (s =~ /^([\d\.-]+)$/)
            $1.to_f
        elsif (s =~ /^([\d\.-]+) in.$/)
            $1.to_f
        elsif (s =~ /^([\d\.-]+) mm.$/)
            $1.to_f / 25.4
        else
            raise "couldn't parse #{s}"
        end
    end

    def set_inches(name, value)
        @shape.cells(name).formula = "#{value} in"
    end
end