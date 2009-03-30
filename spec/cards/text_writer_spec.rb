require File.dirname(__FILE__) + '/../spec_helper'
include Cards

describe TextWriter do
  before do
    @output = TextWriter.new
  end
  
  it "should show simple output for to_s" do
    @output.create_card('a', nil, [0, 0])
    @output.create_card('b', nil, [0, 1])
    @output.create_card('c', nil, [0, 2])
    @output.create_card('d', nil, [2, 2])
    @output.create_card('e', nil, [1, 2])
    @output.create_card('f', nil, [3, 0])
    
    @output.to_s.should == 
"a  f
b
ced"
    @output.inspect.should == 
"|a|||f|
|b|
|c|e|d|"
  end
end
