module Cards
  class CsvBuilder
    def initialize(file_name)
      @file_name = file_name
      @file = File.open(file_name, "wb")
      @csv = CSV::Writer.create(@file)
      @csv << header
    end
  
    def header
      raise "implement me"
    end
  
    def self.from(parser)
      builder = self.new(parser.default_output_file + ".#{self.to_s.gsub("Cards::", "").downcase}.csv")

      parser.each_row do |row|
        builder.process(row)
      end
    
      builder.done
    end
  
    def process(row)
      [:activity, :task, :story].each do |handler|
        send("add_#{handler}", row[handler], row) if row[handler]
      end
    end
  
    def add_activity(name, params = {})
      @activity = name
    end
  
    def add_task(name, params = {})
      @task = name
    end
  
    def add_story(name, params = {})
      raise "implement me"
    end
  
    def done
      @csv.close
      @file.close
      `open #{@file_name.gsub(' ', '\\ ')}`
    end
  end
end