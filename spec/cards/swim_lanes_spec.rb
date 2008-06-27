require File.dirname(__FILE__) + '/../spec_helper'
require 'cards/swim_lanes'
include Cards

describe SwimLanes do
  before do
    @lanes = SwimLanes.new.define do
      row :area
      lanes :pain_points, :by => %w(H M L)
    end
  end
  
  it "should show rows w/ no swim lanes" do
    
  end
  
end