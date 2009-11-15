require 'nokogiri'

class Harness
  module Nokogiri
    class Count
      def perform(xml_input)
        doc = ::Nokogiri.XML(xml_input)
        doc.xpath("//*").size
      end
    end
  end

  def self.parser
    Harness::Nokogiri::Count.new
  end
end
