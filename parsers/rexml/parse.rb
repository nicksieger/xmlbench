require 'rexml/document'

class Harness
  module REXML
    class Parse
      def prepare_input(xml_string)
        xml_string
      end

      def parse(xml_input)
        ::REXML::Document.new(xml_input)
      end

      def search(document, xpath)
        document.root.get_elements(xpath)
      end
    end
  end

  def self.parser
    Harness::REXML::Parse.new
  end
end
