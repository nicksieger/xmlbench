class Harness
  module JavaDOM
    class Parse
      def prepare_input(xml_string)
        @parser = Java::JavaxXmlParsers::DocumentBuilderFactory.newInstance.newDocumentBuilder
        Java::JavaIo::ByteArrayInputStream.new(xml_string.to_java_bytes)
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
