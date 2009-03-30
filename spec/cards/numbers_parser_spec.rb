require File.dirname(__FILE__) + '/../spec_helper'
require 'cards/numbers_parser'

# not the best test, but it will do
describe Cards::NumbersParser do
  describe "each_row" do
    it "should find all rows in Voting Example" do
      file = File.expand_path(File.dirname(__FILE__) + "/../fixtures/Voting Example.numbers")
      parser = Cards::NumbersParser.new(file, "Workflow")
      rows = parser.rows
      rows[0].to_h.should == {:role => "Voter", :task => "Vote on question"}
      rows[1].to_h.should == {:task => "Navigate questions"}
      rows[2].to_h.should == {:task => "Submit"}
      rows[3].to_h.should == {:role => "Admin", :task => "Create questions"}
      rows[4].to_h.should == {:task => "Compile votes"}
      rows[5].to_h.should == {:task => "Announce winners"}
    end
  end
  
  describe "default_output_file" do
    it "should be the table name" do
      Cards::NumbersParser.new("some file.numbers", "larry").default_output_file.should == "larry"
    end
  end
end