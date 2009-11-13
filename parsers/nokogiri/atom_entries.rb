require 'nokogiri'

class Harness
  module Nokogiri
    class AtomEntries
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        doc = ::Nokogiri.XML(xml_input)
        doc.xpath("//atom:entry/atom:title/text()", "atom" => "http://www.w3.org/2005/Atom").map {|e| e.to_s}
      end
    end
  end

  def self.parser
    Harness::Nokogiri::AtomEntries.new
  end
end
