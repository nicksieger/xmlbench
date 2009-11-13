require 'hpricot'

class Harness
  module Hpricot
    class AtomEntries
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        doc = ::Hpricot.XML(xml_input)
        doc.search("//entry/title/text()").map {|el| el.to_s }
      end
    end
  end

  def self.parser
    Harness::Hpricot::AtomEntries.new
  end
end
