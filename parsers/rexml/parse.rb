require 'rexml/document'

class Harness
  module REXML
    class Parse
      def prepare_input(xml_string)
        xml_string
      end

      def perform(xml_input)
        ::REXML::Document.new(xml_input)
      end
    end
  end

  def self.parser
    Harness::REXML::Parse.new
  end
end
