require 'nokogiri'

class Harness
  module Nokogiri
    class XPath
      def perform(xml_input)
        reader = ::Nokogiri::XML::Reader(xml_input)
        titles = []
        text = ''
        grab_text = false
        reader.each do |elem|
          if elem.name == "title"
            if elem.node_type == 1  # start element?
              grab_text = true
            else # elem.node_type == 15  # end element?
              titles << text
              text = ''
              grab_text = false
            end
          elsif grab_text && elem.node_type == 3 # text?
            text << elem.value
          end
        end
      end
    end
  end

  def self.parser
    Harness::Nokogiri::XPath.new
  end
end
