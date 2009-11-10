require 'nokogiri'

class Harness
  module Nokogiri
    class Count
      def prepare_input(xml_string)
        xml_string
      end

      def parse(xml_input)
        doc = ::Nokogiri.XML(xml_input)
        doc.xpath("//*").size
      end
    end
  end

  def self.parser
    Harness::Nokogiri::Count.new
  end
end
