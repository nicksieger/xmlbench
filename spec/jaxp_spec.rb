require File.dirname(__FILE__) + '/spec_helper'

if defined?(Harness::JAXP)
  describe Harness::JAXP::XPath do
    it_should_parse_the_same_as(Harness::REXML::XPath)
  end

  describe Harness::JAXP::Count do
    it_should_parse_the_same_as(Harness::REXML::Count)
  end

  describe Harness::JAXP::Parse do
    it "should parse to a DOM" do
      document = create_driver.run
      document.should respond_to(:document_element)
    end
  end

  describe Harness::JAXP::DOM do
    it "should parse and navigate a DOM and produce a list of strings" do
      create_driver.run.should be_an_array_of_strings
    end
  end

  describe Harness::JAXP::Stream do
    it "should read a stream and produce a list of strings" do
      create_driver.run.should be_an_array_of_strings
    end
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

    it "should parse the titles by xpathing against a pre-parsed document" do
      document = create_driver(Harness::JAXP::Parse).run

      nodes = xpath.evaluate("//atom:entry/atom:title/text()",
                             document, javax.xml.xpath.XPathConstants::NODESET)
      titles = []
      0.upto(nodes.length-1) do |i|
        titles << nodes.item(i).node_value
      end

      titles.should be_an_array_of_strings
    end

    it "should parse the titles by walking a DOM" do
      document = create_driver(Harness::JAXP::Parse).run

      titles = []
      document.traverse do |elem|
        titles << elem.text_content if elem.node_name == "title"
      end

      titles.should be_an_array_of_strings
    end

    it "should grab titles by stream parsing" do
      factory = javax.xml.stream.XMLInputFactory.newInstance
      reader = factory.createXMLStreamReader(xml_stream.to_inputstream)
      titles = []
      text = ''
      grab_text = false
      while reader.has_next
        case reader.next
        when javax.xml.stream.XMLStreamConstants::START_ELEMENT
          grab_text = true if reader.local_name == "title"
        when javax.xml.stream.XMLStreamConstants::CHARACTERS
          text << reader.text if grab_text
        when javax.xml.stream.XMLStreamConstants::END_ELEMENT
          if reader.local_name == "title"
            titles << text
            text = ''
            grab_text = false
          end
        end
      end

      titles.should be_an_array_of_strings
    end

    it "should grab titles by reading events" do
      factory = javax.xml.stream.XMLInputFactory.newInstance
      raw_reader = factory.createXMLEventReader(xml_stream.to_inputstream)

      inside_title = false
      reader = factory.createFilteredReader(raw_reader) do |event|
        keep = true
        if event.start_element? && event.as_start_element.name.local_part == "title"
          inside_title = true
        elsif event.end_element? && event.as_end_element.name.local_part == "title"
          inside_title = false
        elsif !inside_title || !event.characters?
          keep = false
        end
        keep
      end

      titles = []
      text = ''
      while reader.has_next
        event = reader.next_event
        if event.end_element?
          titles << text
          text = ''
        end
        text << event.as_characters.data if event.characters?
      end

      titles.should be_an_array_of_strings
    end
  end
end
