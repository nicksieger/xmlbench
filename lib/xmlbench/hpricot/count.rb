require 'hpricot'

class Harness
  module Hpricot
    class Count
      def perform(xml_input)
        doc = ::Hpricot.XML(xml_input)
        (doc / "//*").select{|el| el.elem?}.size
      end
    end
  end

  def self.parser
    Harness::Hpricot::Count.new
  end
end
