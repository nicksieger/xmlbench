class Harness
  module JAXP
    class Parse
      def prepare_input(xml_stream)
        factory = javax.xml.parsers.DocumentBuilderFactory.newInstance
        factory.namespace_aware = true
        @parser = factory.newDocumentBuilder
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        @parser.parse(xml_input.to_inputstream)
      end
    end
  end

  def self.parser
    Harness::JAXP::Parse.new if defined?(JRUBY_VERSION)
  end
end
