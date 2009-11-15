class Harness
  module JAXP
    class Parse
      def prepare_input(xml_stream)
        factory = javax.xml.parsers.DocumentBuilderFactory.newInstance
        factory.namespace_aware = true
        @parser = factory.newDocumentBuilder
        xml_stream.to_inputstream
      end

      def perform(xml_input)
        @parser.parse(xml_input)
      end
    end
  end

  def self.parser
    Harness::JAXP::Parse.new if defined?(JRUBY_VERSION)
  end
end
