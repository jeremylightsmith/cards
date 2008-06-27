require 'cards/csv_builder'

module Cards
  class TrackerCsv < CsvBuilder
    def header
      ["Story", "Labels", "Story Type", "Estimate", "Description"]
    end

    def add_story(name, params = {})
      return unless [nil, '', 'Story', 'Chore'].include?(params[:story_type])
    
      @csv << [
                name,
                @task,
                params[:story_type],
                nil, # params[:estimate],
                "#{@activity}\n#{params[:description]}"
              ]
    end
  end
end