dir = File.expand_path(File.dirname(__FILE__))
$:.unshift dir
$:.unshift dir + '/excel'
$:.unshift dir + '/visio'

require 'test/unit'
