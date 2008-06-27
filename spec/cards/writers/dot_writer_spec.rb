require File.dirname(__FILE__) + '/../../spec_helper'
require 'cards/writers/dot_writer'
require 'stringio'
include Cards

describe DotWriter do
  CardStruct = Struct.new(:name, :color, :position)
  {
    CardStruct["role", :green, [0,0]] => /card_0_0 \[label="role",fillcolor=darkseagreen1\];/,
    CardStruct["activity", :blue, [0,1]] => /card_0_1 \[label="activity",fillcolor=lightblue\];/,
    CardStruct["task", :red, [0,2]] => /card_0_2 \[label="task",fillcolor=pink\];/,
    CardStruct["feature", :yellow, [0,3]] => /card_0_3 \[label="feature",fillcolor=lightyellow\];/,
  }.each do |card, expected_node|
    it %{given #{card.color} card created with name #{card.name.inspect} in position #{card.position.inspect} it should create node #{expected_node.inspect}} do
      create_card(card.name, card.color, card.position)
      @actual_output.should =~ expected_node
    end
  end
  
  {
    [[0,0],[0,2]] => /gap_0_1 \[style=invis\];/,
    [[0,0],[2,0]] => /gap_1_0 \[style=invis\];/,
    [[0,0],[1,1]] => /gap_1_0 \[style=invis\];/,
  }.each do |card_positions, expected_gap_node|
    it %{given cards created in positions #{card_positions.inspect} it should create invisible node #{expected_gap_node.inspect}} do
      create_cards_in_positions(card_positions)
      @actual_output.should =~ expected_gap_node
    end
  end

  {
    [[0,0],[1,0],[2,0]] => [/card_0_0 -> card_1_0;/,/card_1_0 -> card_2_0;/],                  
    [[0,0],[0,1],[0,2]] => [/card_0_0 -> card_0_1;/,/card_0_1 -> card_0_2;/],
  }.each do |card_positions, edges|
    it %{given cards created in positions #{card_positions.inspect} it should create edges #{edges.inspect} } do
      create_cards_in_positions(card_positions)
      @actual_output.expect(edges)
    end
  end
  
  {
    [[0,0],[1,0]] => [/\{rank=same; card_0_0; card_1_0\};/],
  }.each do |card_positions, ranks|
    it %{given cards created in positions #{card_positions.inspect} it should create ranks #{ranks.inspect} } do
      create_cards_in_positions(card_positions)
      @actual_output.expect(ranks)
    end
  end
  
  def build
    @builder = DotWriter.new(StringIO.new(@actual_output = "", "w+"))
    yield
    @builder.done
  end
  
  def create_cards_in_positions(positions)
    build { positions.each { |position| @builder.create_card("card", :yellow, position)} }
  end
  
  def create_card(name, color, position)
    build { @builder.create_card(name, color, position) }
  end
  
  class String
    def expect(lines)
      lines.each { |line| self.should =~ line }
    end
  end
  
end
