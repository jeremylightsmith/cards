require 'cards/builder'

module Cards
  class CardWall < Builder
    def define(&block)
      DefinitionContext.new(self).instance_eval(&block)
      self
    end

    def self.writer=(writer_class)
      @writer_class = writer_class
    end
    
    def self.colors
      @colors ||= {
        :role => :blue,
        :activity => :blue,
        :task => :red,
        :story => :yellow
      }
    end

    def self.from(parser, &block)
      builder = self.new.define(&block)

      parser.each_row do |row|
        builder.process(row)
      end

      builder.show(@writer_class.new(parser.default_output_file))
    end

    def initialize
      @handlers = []
      @layouts = []
      @root = Card.new("root")
      @root.layout = RowLayout.new
      @root.y = -1
      @last_cards = [@root]
    end
    
    def process(row)
      @handlers.each do |handler|
        unless row[handler].blank?
          send("add_#{handler}", row[handler], row)
        end
      end
    end
    
    def add_handler(type, layout, &block)
      i = @handlers.size
      @handlers << type
      @root.layout = layout if @layouts.empty?
      @layouts << layout
      (class << self; self; end).module_eval do
        define_method("add_#{type}") do |name, row|
          card = yield(name, row)
          card.layout = @layouts[i+1]
          card.color ||= CardWall.colors[type] || :white
          @last_cards[i].add(card)
          @last_cards[i+1] = card
        end
      end
    end

    def show(output)
      @root.layout
      @root.visit {|card| output.create_card(card.name, card.color, card.cell) unless card == @root}
      output.done
    end
        
    class DefinitionContext
      def initialize(wraps)
        @this = wraps
        @i = 0
      end
      
      def row(name, *options)
        @this.add_handler(name, RowLayout.new(*options)) do |name, row|
          Card.new(name)
        end
      end
      
      def column(name, *options)
        @this.add_handler(name, ColumnLayout.new(*options)) do |name, row|
          c = Card.new(name)
          yield c, row if block_given?
          c
        end
      end
      
      def lanes(name, options)
      end
    end
  end
end