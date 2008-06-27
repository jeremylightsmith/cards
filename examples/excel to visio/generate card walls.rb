require File.expand_path(File.dirname(__FILE__)) + '/CardWallGenerator/include.rb'


data = load_excel_data 'Business Processes.xls', 1
create_visio_document data, 'Caution.vsd'

data = load_excel_data 'Business Processes.xls', 2
create_visio_document data, 'TPS.vsd'


