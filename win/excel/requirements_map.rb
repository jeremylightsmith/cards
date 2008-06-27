require 'card'

class RequirementsMap
    attr_reader :activities

    def initialize
        @activities = []
        @card_by_id = {}
    end

    def add(id, name, description, type, estimate)
        card = Card.new(self, id, name, description, type, estimate)
        @activities << card
        update(card)
        card
    end

    def update(card)
        @card_by_id[card.id] = card
    end

    def find_by_id(id)
        @card_by_id[id]
    end

    def bounding_box
        box = Rectangle::empty
        activities.each {|card|
            box.expand_to_include(card.bounding_box)
        }
        box
    end

    def visit(&block)
        activities.each {|card|
            card.visit(&block)
        }
    end

    def dump(indent = "", cards = @activities)
        cards.collect {|card|
            "#{indent}#{card.id} - #{card.name}\n" + dump(indent + "  ", card.children)
        }.join
    end

    def load_from_excel(file, sheet_index = 1)
        raise "file not found #{file}" if !File.exist?(file)
        require 'win32ole'

        excel = WIN32OLE.new('Excel.Application')
        begin
            excel.visible = TRUE
            file = File.expand_path(file).gsub('/', '\\')
            book = open_workbook(excel, file)
            begin
                load_from_worksheet(book.Worksheets(sheet_index))
                raise "couldn't load any requirements" if @activities.size == 0
            ensure
                book.close(false, false, false)
            end
        ensure
            excel.quit
        end
    end

    def open_workbook(excel, file)
        excel.workbooks.open(file, 0, TRUE, 1, '', '', TRUE, nil,
                             9, FALSE, FALSE, nil, FALSE, FALSE, nil)
    end

    def load_from_worksheet(sheet)
        return if sheet == nil
        cells = sheet.cells

        activity = nil
        task = nil
        row = 2
        while(row != -1)
            id, activity_name, task_name, requirement_name, description, type, estimate =
                sheet.range("D#{row}:J#{row}").value[0]
            
            if type && type.downcase == 'ignore'
            elsif requirement_name
                card_type = Card::get_card_type(type, Card::REQUIREMENT)
                if card_type == Card::OTHER && !description
                    description = requirement_name
                    requirement_name = type
                end
                (task ? task : activity).add(id, requirement_name, description, card_type, estimate)
            elsif task_name
                task = activity.add(id, task_name, description, Card::get_card_type(type, Card::TASK), estimate)
            elsif activity_name
                task = nil
                activity = add(id, activity_name, description, Card::get_card_type(type, Card::ACTIVITY), estimate)
            else
                break
            end

            row = row + 1
        end
    end
end