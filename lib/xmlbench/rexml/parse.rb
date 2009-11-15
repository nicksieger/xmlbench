require 'rexml/document'

class Harness
  module REXML
    class Parse
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        ::REXML::Document.new(xml_input)
      end
    end
  end

  def self.parser
    Harness::REXML::Parse.new
  end
end
