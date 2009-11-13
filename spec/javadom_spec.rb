require File.dirname(__FILE__) + '/spec_helper'

if defined?(Harness::JavaDOM)
  describe Harness::JavaDOM::AtomEntries do
    it_should_parse_the_same_as(Harness::REXML::AtomEntries)
  end

  describe Harness::JavaDOM::Count do
    it_should_parse_the_same_as(Harness::REXML::Count)
  end

  describe "Java XML Parsing" do
    def xpath
      xpath = javax.xml.xpath.XPathFactory.newInstance.newXPath
      ns_context = Object.new
      def ns_context.getNamespaceURI(prefix)
        {"atom" => "http://www.w3.org/2005/Atom"}[prefix]
      end
      xpath.namespace_context = ns_context
      xpath
    end

    it "should parse the titles out of an Atom document" do
      input_stream = java.io.ByteArrayInputStream.new(xml_content.to_java_bytes)
      nodes = xpath.evaluate("//atom:entry/atom:title/text()",
                             org.xml.sax.InputSource.new(input_stream),
                             javax.xml.xpath.XPathConstants::NODESET)
      titles = nodes.map {|e| e.node_value}
      titles.should be_an_array_of_strings
    end

    it "should parse the titles out of a stream" do
      nodes = xpath.evaluate("//atom:entry/atom:title/text()",
                             org.xml.sax.InputSource.new(xml_stream.to_inputstream),
                             javax.xml.xpath.XPathConstants::NODESET)
      titles = nodes.map {|e| e.node_value}
      titles.should be_an_array_of_strings
    end
  end
end
