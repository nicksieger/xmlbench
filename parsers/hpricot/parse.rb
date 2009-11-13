require 'hpricot'

class Harness
  module Hpricot
    class Parse
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind
        ::Hpricot.XML(xml_input)
      end
    end
  end

  def self.parser
    Harness::Hpricot::Parse.new
  end
end
