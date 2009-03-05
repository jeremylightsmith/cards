require 'rbosa'
require 'cards/tabular_parser'

module Cards
  class NumbersParser
    include TabularParser
    
    def initialize(file, table_name)
      @file, @table_name = file, table_name
    end

    def each_unparsed_row
      numbers = OSA.app('Numbers')
      document = numbers.open(@file)
      table = find_table(document, @table_name)

      table.rows.each do |row|
        values = []
        row.cells.map do |cell|
          value = cell.value
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
      document.sheets.each do |sheet|
        sheet.tables.each do |table|
          return table if table.name.downcase == name.downcase
        end
      end
      raise "table #{name} not found in #{document.name}"
    end
  end
end
