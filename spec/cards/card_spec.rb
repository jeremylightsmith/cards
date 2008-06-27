require File.dirname(__FILE__) + '/../spec_helper'

require 'cards/card'
require 'cards/layouts/row_layout'
require 'cards/layouts/column_layout'
include Cards

module Cards
  def a() @a ||= new_card("a"); end
  def b() @b ||= new_card("b"); end
  def c() @c ||= new_card("c"); end
  def d() @d ||= new_card("d"); end
  def e() @e ||= new_card("e"); end
  def f() @f ||= new_card("f"); end
  def g() @g ||= new_card("g"); end
  def h() @h ||= new_card("h"); end
  def i() @i ||= new_card("i"); end
  def j() @j ||= new_card("j"); end
  def k() @k ||= new_card("k"); end
  def l() @l ||= new_card("l"); end
  def m() @m ||= new_card("m"); end
  
  def new_card(name)
    Card.new(name)
  end
end

describe Card do
  include Cards
  
  it "should have x & y" do
    a.x = 1
    a.y = 2
    a.x.should == 1
    a.y.should == 2
  end
end

describe Card, "row layout" do
  include Cards
      
  it "should have 1 row" do
    a.add(b, c, d)

    cards_to_s(a).should == 
"a
bcd"
  end
  
  it "should show with 2 rows" do
    a.add(b, g)
    b.add(c, f)
    c.add(d, e)

    cards_to_s(a).should == 
"a
b  g
c f
de"
  end
  
  def cards_to_s(card)
    out = TextWriter.new
    card.layout
    card.visit {|c| out.show(c)}
    out.to_s
  end
  
  def new_card(name)
    c = Card.new(name)
    c.layout = RowLayout.new
    c
  end
end

describe Card, "column layout" do
  include Cards
  
  before do
    a.layout = RowLayout.new
    @layout = ColumnLayout.new
  end

  it "should have 1 column" do
    a.add(b, c, d)
    d.add(e, f)
    c.add(g, h, i)

    cards_to_s(a).should == 
"a
bcd
 ge
 hf
 i"
  end
  
  it "should show with 2 rows and then columns" do
    a.add(b, c, d)
    a.children.each {|child| child.layout = RowLayout.new}
    b.add(e, f, g)
    d.add(h)
    h.add(i, j)
    f.add(k, l, m)

    cards_to_s(a).should == 
"a
b  cd
efg h
 k  i
 l  j
 m"
  end
  
  it "should wrap" do
    @layout = ColumnLayout.new(:wrap_at => 3)
    a.add(b, c, d)
    c.add(e, f, g, h, i, j, k)
    d.add(l, m)
    
    cards_to_s(a).should == 
"a
bc  d
 ehkl
 fi m
 gj"
    
  end
  
  def cards_to_s(card)
    out = TextWriter.new
    card.layout
    card.visit {|c| out.show(c)}
    out.to_s
  end
  
  def new_card(name)
    c = Card.new(name)
    c.layout = @layout
    c
  end
end
