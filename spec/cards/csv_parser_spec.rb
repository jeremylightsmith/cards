require File.dirname(__FILE__) + '/../spec_helper'

require 'file_sandbox_behavior'
require 'cards/csv_parser'
include Cards

describe CsvParser do
  include FileSandbox
  
  before do
    sandbox.new :file => 'tmp.csv', :with_contents =>
"activity,task,story,estimate
manage email,,
,read email,
,,display email body
manage email,think about email,mow the lawn,1
,read email,,2
,,display email body,3"
  end
  
  it "should parse csv" do    
    rows = CsvParser.new(sandbox['tmp.csv'].path).rows
    rows[0].to_h.should == {:activity => 'manage email'}
    rows[1].to_h.should == {:task => 'read email'}
    rows[2].to_h.should == {:story => 'display email body'}
    rows[3].to_h.should == {:activity => 'manage email', :task => 'think about email', :story => 'mow the lawn', :estimate => "1"}
    rows[4].to_h.should == {:task => 'read email', :estimate => "2"}
    rows[5].to_h.should == {:story => 'display email body', :estimate => "3"}
  end
end
