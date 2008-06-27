require 'visio'

include Visio

visio = connect()
doc = open_document(visio, File.dirname(__FILE__) + '/tmp.vsd')
doc.pages(1).shapes.each {|shape|
    puts dump(shape)

    puts shape.Id
    x, y, width, height =
        shape.cells("PinX").formula, shape.cells("PinY").formula, shape.cells("Width").formula, shape.cells("Height").formula
    puts "    #{x}, #{y}, #{width}, #{height}"
}