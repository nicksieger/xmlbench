require 'hpricot'

class Harness
  module Hpricot
    class XPath
      def perform(xml_input)
        doc = ::Hpricot.XML(xml_input)
        doc.search("//entry/title/text()").map {|el| el.to_s }
      end
    end
  end

  def self.parser
    Harness::Hpricot::XPath.new
  end
end
