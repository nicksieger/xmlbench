require 'xmlbench/java_helpers'

class Harness
  module JAXP
    class DOM
      def prepare_input(xml_stream)
        factory = javax.xml.parsers.DocumentBuilderFactory.newInstance
        factory.namespace_aware = true
        @parser = factory.newDocumentBuilder
        xml_stream.to_bytearray_inputstream
      end

      def perform(xml_input)
        xml_input.reset
        document = @parser.parse(xml_input)
        titles = []
        document.traverse do |elem|
          titles << elem.text_content if elem.node_name == "title"
        end
        titles
      end
    end
  end

  def self.parser
    Harness::JAXP::DOM.new if defined?(JRUBY_VERSION)
  end
end
