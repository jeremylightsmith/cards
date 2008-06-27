require 'visio'
require 'shape_aware_card'

class Array
    def width() self[0] end
    def width=(value) self[0]=value end
    def height() self[1] end
    def height=(value) self[1]=value end
end

class VisioGenerator
    include Visio

    attr_reader :visio

    def initialize
        @visio = connect()
    end

    def create(map, file, layout)
        file = normalize_file_name(file)
        template_file = normalize_file_name(File.dirname(__FILE__) + '/Art Template.vst')
        doc = visio.documents.add template_file
        doc.footercenter = "&d &t"
        page = doc.pages(1)

        scope_id = visio.beginUndoScope('create_requirement_map')
        begin
            layout.layout(map)
            resize_page_and_center_cards(map, page, layout.spacing * 0.8)

            update_shapes(map.activities, page)

            visio.endUndoScope(scope_id, true);

            doc.saveas file

        rescue
            visio.endUndoScope(scope_id, false);
            raise
        end
    end

    private

    def update_shapes(cards, page)
        cards.each {|card|
            if card.shape_id
                shape = page.shapes.itemFromId(card.shape_id)
                card.update_shape(shape)
            else
                card.create_shape(self, page)
            end

            update_shapes(card.children, page) if card.children.size > 0
        }
    end

    def resize_page_and_center_cards(map, page, spacing)
        bounds = map.bounding_box
        width = bounds.right - bounds.left + (spacing * 2)
        height = bounds.top - bounds.bottom + (spacing * 2)

        cell = page.pagesheet.cellsSRC(Visio::VisSectionObject,
                                       Visio::VisRowPage,
                                       Visio::VisPageWidth)
        cell.formula = width.to_s
        cell = page.pagesheet.cellsSRC(Visio::VisSectionObject,
                                           Visio::VisRowPage,
                                           Visio::VisPageHeight)
        cell.formula = height.to_s

        offset = [spacing - bounds.left, bounds.bottom - spacing]
        map.visit {|card|
            card.x += offset[0]
            card.y -= offset[1]
        }

        window = page.application.activewindow
        window.setviewrect(0, height, width, height)
    end
end