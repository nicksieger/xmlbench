require 'rexml/document'

class Harness
  module REXML
    class Count
      def perform(xml_input)
        ::REXML::Document.new(xml_input).root.get_elements("//*").size
      end
    end
  end

  def self.parser
    Harness::REXML::Count.new
  end
end
