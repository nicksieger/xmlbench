require 'nokogiri'

class Harness
  module Nokogiri
    class DOM
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        document = ::Nokogiri::XML(xml_input)
        titles = []
        document.root.traverse do |elem|
          titles << elem.content if elem.name == "title"
        end
      end
    end
  end

  def self.parser
    Harness::Nokogiri::DOM.new
  end
end
