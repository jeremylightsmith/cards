module Cards
  class DotWriter
    def initialize(file)
      if file.respond_to? :puts
        @file = file
      else
        @file = File.open(file + ".dot", "w")
      end
      @node_color = {:green => "darkseagreen1", :blue => "lightblue", :red => "pink", :yellow => "lightyellow"}
      @nodes = []

      puts "digraph G {"
      puts "graph [nodesep=.1, ranksep=.1, ordering=out];"
      puts "node [shape=box, color=black, style=filled, width=2, height=1.2, fixedsize=true, labeljust=\"l\"];"
      puts "edge [style=invis, weight=1];"
    end
  
    def puts(string)
      @file.puts string
    end
  
    def create_card(name, color, position)
      create_node("card", position, %{label="#{wrap(name)}",fillcolor=#{@node_color[color]}})
    end
  
    def done
      create_gap_nodes
      create_ranks
      create_edges
      puts "}"
      @file.close
    end  
  
    private
  
    def create_node(name, position, properties)
      node_id = name.gsub(/\s*/, "")[0, 10] << "_" << position.join("_")
      x = position[0]; y = position[1]
      column = @nodes[x] == nil ? @nodes[x] = [] : @nodes[x]
      column[y] = node_id
      puts %{#{node_id} [#{properties}];}
    end
  
    def create_gap_nodes
      @nodes.each_index do |x|
        if !@nodes[x] 
          create_gap([x,0])
        else
          @nodes[x].each_index do |y|
            create_gap([x,y]) unless @nodes[x][y]
          end
        end 
      end
    end
  
    def create_gap(position)
      create_node("gap", position, "style=invis")
    end
  
    def create_ranks
      3.times do |y|
        rank = "{rank=same"
        @nodes.each_index { |x| rank += "; #{@nodes[x][y]}" if @nodes[x][y] }
        rank << "};"
        puts rank
      end
    end
  
    def create_edges
      (@nodes.length-1).times do |x|
        create_edge(@nodes[x][0], @nodes[x+1][0])
      end
    
      @nodes.each do |column|
        (column.length-1).times do |y|
          create_edge(column[y], column[y+1])
        end
      end
    end
  
    def create_edge(node1, node2)
      puts %{#{node1} -> #{node2};}
    end
  
    def wrap(text)
      label_width = 20
      text.gsub(/\n/," ").scan(/\S.{0,#{label_width-2}}\S(?=\s|$)|\S+/).join("\\n")
    end
  end
end