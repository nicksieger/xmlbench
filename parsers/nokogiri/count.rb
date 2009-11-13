require 'nokogiri'

class Harness
  module Nokogiri
    class Count
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind
        doc = ::Nokogiri.XML(xml_input)
        doc.xpath("//*").size
      end
    end
  end

  def self.parser
    Harness::Nokogiri::Count.new
  end
end
