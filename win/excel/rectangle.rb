class Rectangle
    attr_accessor :left, :top, :right, :bottom

    def Rectangle::empty
        Rectangle.new(nil, nil, nil, nil)
    end

    def initialize(left, top, right, bottom)
        @left, @top, @right, @bottom = [left, top, right, bottom]
    end

    def expand_to_include(other)
        @left = other.left      if !@left   || (other.left && other.left < @left)
        @top = other.top        if !@top    || (other.top && other.top > @top)
        @right = other.right    if !@right  || (other.right && other.right > @right)
        @bottom = other.bottom  if !@bottom || (other.bottom && other.bottom < @bottom)
    end

    def intersects(rect)
        rect.left < right && rect.top < bottom &&
            rect.right > left && rect.bottom > top
    end

    def ==(other)
        other.left == @left &&
        other.top == @top &&
        other.right == @right &&
        other.bottom == @bottom
    end

    def to_s
        "(l=#{left}, top=#{top}, r=#{right}, b=#{bottom})"
    end

    def inspect
        "rect(l=#{left}, top=#{top}, r=#{right}, b=#{bottom})"
    end
end
