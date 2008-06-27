class Text
  def add_role(name, params = {})
    puts name
  end
  
  def add_activity(name, params = {})
    puts "  #{name}"
  end
  
  def add_task(name, params = {})
    puts "    #{name}"
  end
  
  def add_story(name, params = {})
    string = "      #{name}"
    string << " - #{params[:description]}" unless params[:description].blank?
    string << " - #{params[:estimate]}" unless params[:estimate].blank?
    puts string
  end
  
  def done
  end
end