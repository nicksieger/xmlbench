module org::w3c::dom::NodeList
  include Enumerable
  def each
    0.upto(length - 1) do |i|
      yield item(i)
    end
  end
end

class Harness
  module JavaDOM
    class AtomEntries
      def prepare_input(xml_stream)
        @xpath = javax.xml.xpath.XPathFactory.newInstance.newXPath
        ns_context = Object.new
        def ns_context.getNamespaceURI(prefix)
          {"atom" => "http://www.w3.org/2005/Atom"}[prefix]
        end
        @xpath.namespace_context = ns_context
        @expr = @xpath.compile("//atom:entry/atom:title/text()")
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        nodes = @expr.evaluate(org.xml.sax.InputSource.new(xml_input.to_inputstream),
                               javax.xml.xpath.XPathConstants::NODESET)
        nodes.map{|e| e.node_value}
      end
    end
  end

  def self.parser
    Harness::JavaDOM::AtomEntries.new
  end
end
