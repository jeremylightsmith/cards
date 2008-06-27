require 'card'

class DefaultCardLayout
    Spacing = 0.2
    CardsInColumn = 4

    def spacing
    	Spacing
    end
    
    def layout(map)
        pos = Position.new()
        map.activities.each {|activity|
            pos.place(activity)
            pos.move_below(activity)
            activity.children.each {|task|
                pos.place(task)
                pos.move_below(task)

                top_req = task.children.size != 0 ? task.children[0] : nil
                for i in 0..task.children.size-1
                    req = task.children[i]
                    if i != 0 && i % CardsInColumn == 0
                        pos.move_to_the_right_of(top_req)
                        top_req = req
                    end

                    pos.place(req)
                    pos.move_below(req)
                end
                pos.x += task.width + Spacing
                pos.y = task.y
            }
            pos.y = activity.y
        }
    end

    class Position
        attr_accessor :x, :y

        def initialize
            @x, @y = 0, 0
        end

        def place(card)
            if (!card.has_been_positioned)
                card.x, card.y = [x, y]
            end
        end

        def move_below(card)
            @x = card.x
            @y = card.y - (card.height + Spacing)
        end

        def move_to_the_right_of(card)
            @x = card.x + card.width + Spacing
            @y = card.y
        end
    end
end