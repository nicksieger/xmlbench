require 'hpricot'

class Harness
  module Hpricot
    class Parse
      def perform(xml_input)
        ::Hpricot.XML(xml_input)
      end
    end
  end

  def self.parser
    Harness::Hpricot::Parse.new
  end
end
