module Cards
  class RowLayout
    def layout(card)
      x = card.x
      card.children.each_with_index do |child, i|
        child.x = x
        child.y = card.y + 1
        child.layout
        x += child.width
      end
    end
    
    def width(card)
      card.children.map {|c| c.width}.sum
    end
    
    def height(card)
      card.children.map {|c| c.height}.max
    end
  end
end
