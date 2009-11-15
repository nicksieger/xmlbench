require 'nokogiri'

class Harness
  module Nokogiri
    class XPath
      def perform(xml_input)
        doc = ::Nokogiri.XML(xml_input)
        doc.xpath("//atom:entry/atom:title/text()", "atom" => "http://www.w3.org/2005/Atom").map {|e| e.to_s}
      end
    end
  end

  def self.parser
    Harness::Nokogiri::XPath.new
  end
end
