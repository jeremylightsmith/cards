= Project: Cards

== Description

CardWallGen is a program that reads a requirements map and generates a view 
of it.  Typically it reads it from excel or csv and generates a graphical 
view in visio or omnigraffle, though it may also generate another csv view of it.

== Usage

We try to make it simple to configure.  However, you still need a driver file 
that might look something like :

  CardWall.from csv_file("Business Goals") do
    column :goal
  end

  CardWall.from csv_file("Current Workflow") do
    row :activity
    column :task
  end

  CardWall.from csv_file("Stories") do
    row :activity
    row :task
    column :story, :wrap_at => 4 do |card, row|
      card.name << "\n\n#{row[:description]}" unless row[:description].blank?    
      card.name << "\n\n                           " 
    end
  end

  MasterStoryList.from csv_file("Stories")

  TrackerCsv.from csv_file("Stories")

== Contact

Author::     Jeremy Lightsmith
Email::      jeremy.lightsmith@gmail.com
License::    LGPL License

== Home Page

http://github.com/jeremylightsmith/cards
