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
      def prepare_input(xml_string)
        @xpath = javax.xml.xpath.XPathFactory.newInstance.newXPath
        ns_context = Object.new
        def ns_context.getNamespaceURI(prefix)
          {"atom" => "http://www.w3.org/2005/Atom"}[prefix]
        end
        @xpath.namespace_context = ns_context
        Java::JavaIo::ByteArrayInputStream.new(xml_string.to_java_bytes)
      end

      def parse(xml_input)
        xml_input.reset
        nodes = @xpath.evaluate("//atom:entry/atom:title/text()",
                                org.xml.sax.InputSource.new(xml_input),
                                javax.xml.xpath.XPathConstants::NODESET)
        nodes.map{|e| e.node_value}
      end
    end
  end

  def self.parser
    Harness::JavaDOM::AtomEntries.new
  end
end
