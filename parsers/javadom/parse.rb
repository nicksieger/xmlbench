class Harness
  module JavaDOM
    class Parse
      def prepare_input(xml_stream)
        @parser = Java::JavaxXmlParsers::DocumentBuilderFactory.newInstance.newDocumentBuilder
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        @parser.parse(xml_input.to_inputstream)
      end
    end
  end

  def self.parser
    Harness::JavaDOM::Parse.new if defined?(JRUBY_VERSION)
  end
end
