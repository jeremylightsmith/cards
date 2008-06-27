require 'enumerator'

module Cards
  class ColumnLayout
    def initialize(options = {})
      @wrap_at = options.delete(:wrap_at) || 10
    end
    
    def layout(card)
      x = card.x
      card.children.each_slice(@wrap_at) do |slice|
        y = card.y + 1
        slice.each do |child|
          child.x, child.y = x, y
          child.layout
          y += child.height
        end
        x += slice.widths.max
      end
    end
    
    def width(card)
      width = 0
      card.children.each_slice(@wrap_at) do |slice|
        width += slice.widths.max
      end
      width
    end
    
    def height(card)
      card.children.heights.sum
    end
  end
end
