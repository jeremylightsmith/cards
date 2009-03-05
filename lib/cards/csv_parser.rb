require 'csv'
require 'cards/tabular_parser'

module Cards
  class CsvParser
    include TabularParser
    
    def initialize(file)
      @file = file
    end

    def each_unparsed_row
      CSV.open(@file, 'r') do |row|
        yield row
      end
    end
    
    def default_output_file
      File.basename(@file).sub(/\..*/, '')
    end
  end
end
