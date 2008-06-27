class String
  def blank?
    self.size == 0 || self.strip.size == 0
  end

  def no_spaces
    self.gsub(' ', '\\ ')
  end

  def as(extension)
    self.gsub(/\.[^\/]+$/, '') + ".#{extension}"
  end

  def exists?
    File.exist?(self)
  end

  def delete_if_exists
    File.delete(self) if self.exists?
  end

  def run
    puts self
    `#{self}`
  end
end

class Array
  def sum
    s = 0
    each {|i| s += i}
    s
  end
  
  def widths
    map {|c| c.width}
  end
  
  def heights
    map {|c| c.height}
  end
end

class Numeric
  def inches # as points
    self * 72.0
  end
end

class Object
  def blank?
    nil?
  end
  
  def dump_methods(ignore = Object)
    ignore = ignore.instance_methods if ignore.is_a? Class
    p (methods - ignore).sort
  end
end
