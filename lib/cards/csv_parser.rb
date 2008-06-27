require 'csv'

module Cards
  class CsvParser
    def initialize(file)
      @file = file
    end

    def rows
      rows = []
      each_row {|row| rows << row}
      rows
    end
    
    def each_row
      header = nil
      CSV.open(@file, 'r') do |row|
        if header.nil?
          header = define_header(row)
        else
          yield Row.new(header, row)
        end
      end
    end
  
    def default_output_file
      File.basename(@file).sub(/\..*/, '')
    end
    
    private

    def define_header(header_row)
      header = {}
      header_row.each_with_index do |name, i|
        header[name.downcase.gsub(' ', '_').to_sym] = i
      end
      return header
    end

    class Row
      def initialize(header, row)
        @header, @row = header, row
      end

      def [](key)
        index = @header[key] || raise("can't find column header #{key.inspect} in #{@header.inspect}")
        @row[index]
      end

      def to_h
        h = {}
        @header.each_key do |column_header|
          val = @row[@header[column_header]]
          h[column_header] = val unless val.blank?
        end
        h
      end
    end
  end
end
