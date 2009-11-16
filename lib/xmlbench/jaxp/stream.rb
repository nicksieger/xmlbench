require 'xmlbench/java_helpers'

class Harness
  module JAXP
    class Stream
      def prepare_input(xml_stream)
        @factory = javax.xml.stream.XMLInputFactory.newInstance
        xml_stream.to_bytearray_inputstream
      end

      def perform(xml_input)
        xml_input.reset
        reader = @factory.createXMLStreamReader(xml_input)
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
        titles
      end
    end
  end

  def self.parser
    Harness::JAXP::Stream.new if defined?(JRUBY_VERSION)
  end
end
