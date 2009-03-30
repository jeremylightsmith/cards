# this is making this a mac only distro, I'm afraid
gem 'rb-appscript'
require 'appscript'
require 'cards/tabular_parser'

module Cards
  class NumbersParser
    include TabularParser
    
    def initialize(file, table_name)
      @file, @table_name = file, table_name
    end

    def each_unparsed_row
      numbers = Appscript.app('Numbers')
      document = numbers.open(@file)
      table = find_table(document, @table_name)

      table.rows.get.each do |row|
        values = []
        row.cells.get.map do |cell|
          value = cell.value.get
          value = nil if value == 0
          values << value
        end
        yield values
      end
    end

    def default_output_file
      @table_name
    end
    
    private
    
    def find_table(document, name)
      document.sheets.get.each do |sheet|
        sheet.tables.get.each do |table|
          return table if table.name.get.downcase == name.downcase
        end
      end
      raise "table #{name} not found in #{document.name}"
    end
  end
end
