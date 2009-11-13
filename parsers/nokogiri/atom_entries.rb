require 'nokogiri'

class Harness
  module Nokogiri
    class AtomEntries
      def prepare_input(xml_string)
        xml_string
      end

      def parse(xml_input)
        doc = ::Nokogiri.XML(xml_input)
        doc.xpath("//atom:entry/atom:title/text()", "atom" => "http://www.w3.org/2005/Atom").map {|e| e.to_s}
      end
    end
  end

  def self.parser
    Harness::Nokogiri::AtomEntries.new
  end
end
