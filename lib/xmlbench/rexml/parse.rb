require 'rexml/document'

class Harness
  module REXML
    class Parse
      def perform(xml_input)
        ::REXML::Document.new(xml_input)
      end
    end
  end

  def self.parser
    Harness::REXML::Parse.new
  end
end
