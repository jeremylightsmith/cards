$:.unshift File.expand_path(File.dirname(__FILE__)) + '/excel'
$:.unshift File.expand_path(File.dirname(__FILE__)) + '/visio'
require 'requirements_map'
require 'visio_generator'
require 'default_card_layout'

if (ARGV.size == 0)
    puts "usage : ruby excel2visio.rb <my excel file>"
    exit
end

include Visio

excel_file = ARGV[0]
map = RequirementsMap.new
map.load_from_excel(excel_file)

visio_file = excel_file.index('.xls') ? excel_file.gsub('.xls', '.vsd') : excel_file + '.vsd'
generator = VisioGenerator.new
layout = DefaultCardLayout.new
puts "creating #{visio_file}"
generator.create(map, visio_file, layout)
