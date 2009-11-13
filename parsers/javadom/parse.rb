class Harness
  module JavaDOM
    class Parse
      def prepare_input(xml_stream)
        @parser = Java::JavaxXmlParsers::DocumentBuilderFactory.newInstance.newDocumentBuilder
        xml_stream.to_inputstream
      end

      def perform(xml_input)
        xml_input.reset
        @parser.parse(xml_input)
      end
    end
  end

  def self.parser
    Harness::JavaDOM::Parse.new if defined?(JRUBY_VERSION)
  end
end
