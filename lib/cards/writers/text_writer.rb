module Cards
  class TextWriter
    def initialize
      @rows = []
    end
  
    def show(card)
      create_card(card.name, card.color, card.cell)
    end
  
    def create_card(name, color, cell)
      (@rows[cell[1]] ||= [])[cell[0]] = name
    end
    
    def done
    end
  
    def to_s
      @rows.map{|row| row.map{|val| val ? val : " " }.join }.join("\n")
    end
  
    def inspect
      @rows.map{|row| "|#{row.join("|")}|" }.join("\n")
    end
  end
end