require 'rexml/document'

class Harness
  module REXML
    class Count
      def prepare_input(xml_string)
        xml_string
      end

      def perform(xml_input)
        ::REXML::Document.new(xml_input).root.get_elements("//*").size
      end
    end
  end

  def self.parser
    Harness::REXML::Count.new
  end
end
