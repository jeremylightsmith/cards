require File.dirname(__FILE__) + '/../spec_helper'

describe "String extensions" do
  it "should know what's blank" do
    nil.should be_blank
    "".should be_blank
    "  \t\n".should be_blank
    "a".should_not be_blank
  end
end

describe "Array extensions" do
  it "should have max" do
    [1, 2, 5, 4].max.should == 5
  end

  it "should have min" do
    [1, 2, 5, 4].min.should == 1    
  end

  it "should compute sum" do
    [1, 2, 3].sum.should == 6
  end
end