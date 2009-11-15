require 'xmlbench/java_helpers'

class Harness
  module JAXP
    class XPath
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
    Harness::JAXP::XPath.new if defined?(JRUBY_VERSION)
  end
end
