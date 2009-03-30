# this is making this a mac only distro, I'm afraid
gem 'rb-appscript'
require 'appscript'

module Cards
  class GraffleWriter
    CARD_WALL_STENCIL = File.expand_path(File.dirname(__FILE__) + "/CardWall.gstencil")
    COLORS = {
      :green => [0xcccc, 0xffff, 0xcccc],
      :red => [0xffff, 0xcccc, 0xcccc],
      :yellow => [0xffff, 0xffff, 0xcccc],
      :blue => [0xcccc, 0xcccc, 0xffff],
      :white => [0xffff, 0xffff, 0xffff]
    }
    CARD_WIDTH = 2.875.inches
    CARD_HEIGHT = 2.875.inches
    CARD_PADDING = 0.4.inches
    
    attr_reader :app
  
    def initialize(name = "Card Wall", omnigraffle_app = "OmniGraffle 4")
      @app = Appscript.app(omnigraffle_app)
      @doc = @app.documents[0]
      puts "opening #{name}"
      open_document(name)
      activate
      clear_shapes
    end
  
    def open_document(name)
      @doc = @app.documents[name]
      return @doc if @doc.exists
    
      @doc = @app.make :new => :document, :with_properties => {:name => name}
      canvas.adjusts_pages.set true
      @app.windows[name].zoom.set 0.2
    end
  
    def clear_shapes
      canvas.shapes.get.each do |shape|
        shape.delete
      end
    end
  
    def create_card(text, color = :yellow, cell = [0, 0])
      canvas.make :new => :shape, 
                  :with_properties => {
                    :origin => [cell[0] * (CARD_WIDTH + CARD_PADDING),
                                cell[1] * (CARD_HEIGHT + CARD_PADDING)], 
                    :size => [CARD_WIDTH, CARD_HEIGHT],
                    :fill_color => COLORS[color],
                    :text => {:size => 16.0, :text => text}
                  }
    end
  
    def done
    end
    
    def canvas
      @doc.canvases[0]
    end
  
    def method_missing(sym, *args)
      @app.send(sym, *args)
    end
  end
end
