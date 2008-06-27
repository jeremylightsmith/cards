require File.dirname(__FILE__) + '/../spec_helper'

require 'cards/card_wall'
include Cards

describe CardWall, "row, col" do
  before do
    @builder = CardWall.new.define do
      row :activity
      column :task
    end
    @out = TextWriter.new
  end

  it "should display cards" do
    @builder.process :activity => 'a', :task => 1
    @builder.process :task => 2
    @builder.process :task => 3
    @builder.process :activity => 'b', :task => 4
    @builder.process :activity => 'c', :task => 5
    @builder.process :task => 6
    @builder.process :task => 7
    @builder.process :task => 8
    @builder.process :task => 9
    @builder.process :task => 0
    @builder.process :task => 1
    @builder.process :activity => 'd', :task => 2

    @builder.show(@out)
    @out.to_s.should == 
"abcd
1452
2 6
3 7
  8
  9
  0
  1"
  end
end

describe CardWall, "row, row, col" do
  before do
    @builder = CardWall.new.define do
      row :activity
      row :task
      column :story
    end
    @out = TextWriter.new
  end

  it "should display cards" do
    @builder.process :activity => 'a', :task => 1, :story => 'A'
    @builder.process :task => 2, :story => 'B'
    @builder.process :story => 'C'
    @builder.process :task => 3, :story => 'D'
    @builder.process :activity => 'b', :task => 4
    @builder.process :activity => 'c', :task => 5
    @builder.process :task => 6, :story => 'E'
    @builder.process :story => 'F'
    @builder.process :story => 'G'
    @builder.process :story => 'H'
    @builder.process :task => 7
    @builder.process :task => 8
    @builder.process :activity => 'd', :task => 2, :story => 'I'

    @builder.show(@out)
    @out.to_s.should == 
"a  bc   d
123456782
ABD  E  I
 C   F
     G
     H"
  end
end
