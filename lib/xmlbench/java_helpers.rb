if defined?(JRUBY_VERSION)
module org::w3c::dom::NodeList
  include Enumerable
  def each
    0.upto(length - 1) do |i|
      yield item(i)
    end
  end
end

module org::w3c::dom::Node
  def traverse(&blk)
    blk.call(self)
    child_nodes.each do |e|
      e.traverse(&blk)
    end
  end
end

module ToByteArrayInputStream
  def to_bytearray_inputstream
    java.io.ByteArrayInputStream.new(read.to_java_bytes)
  end
end

class IO
  include ToByteArrayInputStream
end

require 'stringio'
class StringIO
  include ToByteArrayInputStream
end
end
