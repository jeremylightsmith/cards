$:.unshift File.expand_path(File.dirname(__FILE__)) + '/excel'
$:.unshift File.expand_path(File.dirname(__FILE__)) + '/visio'
require 'requirements_map'
require 'visio_generator'
require 'default_card_layout'

include Visio

def load_excel_data(excel_file, sheet_name)
    map = RequirementsMap.new
    map.load_from_excel(normalize_file_name(excel_file), sheet_name)
    map
end

def create_visio_document(map, visio_file, layout = DefaultCardLayout.new)
    puts "creating #{visio_file}"
    generator = VisioGenerator.new
    generator.create(map, visio_file, layout)
end
