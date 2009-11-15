class Harness
  module JAXP
    class Count
      def prepare_input(xml_stream)
        @xpath = javax.xml.xpath.XPathFactory.newInstance.newXPath
        @expr = @xpath.compile("count(//*)")
        xml_stream.to_inputstream
      end

      def perform(xml_input)
        @expr.evaluate(org.xml.sax.InputSource.new(xml_input),
                       javax.xml.xpath.XPathConstants::NUMBER)
      end
    end
  end

  def self.parser
    Harness::JAXP::Count.new if defined?(JRUBY_VERSION)
  end
end
