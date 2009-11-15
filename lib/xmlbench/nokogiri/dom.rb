require 'nokogiri'

class Harness
  module Nokogiri
    class DOM
      def perform(xml_input)
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
