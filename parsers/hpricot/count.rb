require 'hpricot'

class Harness
  module Hpricot
    class Count
      def prepare_input(xml_string)
        xml_string
      end

      def parse(xml_input)
        doc = ::Hpricot.XML(xml_input)
        doc.search("//*").size
      end
    end
  end

  def self.parser
    Harness::Hpricot::Count.new
  end
end
