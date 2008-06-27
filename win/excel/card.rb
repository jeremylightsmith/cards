require 'rectangle'

class Card
    DEFAULT_WIDTH = 3
    DEFAULT_HEIGHT = 3


    ACTIVITY = 'Activity'
    TASK = 'Task'
    REQUIREMENT = 'Requirement'
    RISK = 'Risk'
    OTHER = 'Other'

    attr_accessor :x, :y, :width, :height, :has_been_positioned
    attr_reader :id, :name, :description, :type, :children

    def initialize(map, id, name, description, type, estimate)
        @map, @id, @name, @description, @type = map, id, name, description, type
        @children = []
        @x, @y, @width, @height = [0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT]
        @has_been_positioned = false

        if estimate
            @name += " (#{estimate})"
        end
    end

    def add(id, name, description, type, estimate)
        card = Card.new(@map, id, name, description, type, estimate)
        @children << card
        @map.update(card)
        card
    end

    def Card::get_card_type(type, default)
        case type
            when nil, ''             then default
            when ACTIVITY       then ACTIVITY
            when TASK           then TASK
            when REQUIREMENT    then REQUIREMENT
            when RISK           then RISK
            else                OTHER
        end
    end

    def location
        [x, y]
    end

    def bounding_box
        box = Rectangle.new(x, y, x + width, y - height)
        children.each {|child|
            box.expand_to_include(child.bounding_box)
        }
        box
    end

    def visit(&block)
        yield self
        children.each {|card|
            card.visit(&block)
        }
    end
end