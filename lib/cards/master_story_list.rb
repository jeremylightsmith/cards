require 'cards/csv_builder'

module Cards
  # this is an example of a custom csv builder that you can create
  class MasterStoryList < CsvBuilder
    def header
      ["Activity", "Task", "Story", "Description", "Estimate", "Phase", "Priority"]
    end
  
    def add_story(name, params = {})
      return unless [nil, '', 'Story', 'Chore'].include?(params[:story_type])
    
      @csv << [
                @activity,
                @task,
                name,
                params[:description],
                nil, # params[:estimate],
                nil, # params[:phase],
                nil  # params[:priority]
              ]
    end
  end
end
