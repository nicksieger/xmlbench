class Harness
  module JavaDOM
    class Count
      def prepare_input(xml_string)
        @xpath = javax.xml.xpath.XPathFactory.newInstance.newXPath
        @expr = @xpath.compile("count(//*)")
        java.io.ByteArrayInputStream.new(xml_string.to_java_bytes)
      end

      def parse(xml_input)
        xml_input.reset
        @expr.evaluate(org.xml.sax.InputSource.new(xml_input),
                       javax.xml.xpath.XPathConstants::NUMBER)
      end
    end
  end

  def self.parser
    Harness::JavaDOM::Count.new
  end
end
