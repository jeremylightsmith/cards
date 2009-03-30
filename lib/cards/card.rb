module Cards
  class Card
    attr_accessor :name, :color, :children, :x, :y
    attr_writer :layout
    
    def initialize(name)
      @name = name
      @x, @y = 0, 0
      @children = []
    end
        
    def add(*cards)
      @children += cards
    end
    
    def visit(&block)
      yield self
      @children.each {|c| c.visit(&block) }
    end
    
    def layout
      my_layout.layout(self)
    end
    
    def width
      return 1 if children.empty?
      my_layout.width(self)
    end
    
    def height
      return 1 if children.empty?
      my_layout.height(self)
    end
        
    def cell() [x, y]; end
    def cell=(cells) self.x, self.y = *cells; end
    
    private
    
    def my_layout
      @layout || Layouts::NilLayout.new
    end
  end
end