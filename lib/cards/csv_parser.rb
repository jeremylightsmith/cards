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
    
    # this method will turn something of the form
    #
    # activity | task    | story   |
    # a        |         |         |
    #          | b       |         |
    #          |         | c       |
    #          |         | d       |
    #
    # into 
    #
    # activity | task    | story   |
    # a        | b       | c       |
    # a        | b       | d       |
    #
    def denormalized_rows(key_column, columns_to_denormalize)
      last_row = {}
      rows = []
      each_row do |row|
        row = row.to_h
        columns_to_denormalize.each do |c|
          row[c] = last_row[c] if row[c].blank?
        end
        rows << row unless row[key_column].blank?
        last_row = row
      end
      rows
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
