require 'hpricot'

class Harness
  module Hpricot
    class Count
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind
        doc = ::Hpricot.XML(xml_input)
        (doc / "//*").select{|el| el.elem?}.size
      end
    end
  end

  def self.parser
    Harness::Hpricot::Count.new
  end
end
