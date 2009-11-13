require 'hpricot'

class Harness
  module Hpricot
    class AtomEntries
      def prepare_input(xml_string)
        xml_string
      end

      def parse(xml_input)
        doc = ::Hpricot.XML(xml_input)
        doc.search("//entry/title/text()").map {|el| el.to_s }
      end
    end
  end

  def self.parser
    Harness::Hpricot::AtomEntries.new
  end
end
