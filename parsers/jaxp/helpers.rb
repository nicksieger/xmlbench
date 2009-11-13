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
end
