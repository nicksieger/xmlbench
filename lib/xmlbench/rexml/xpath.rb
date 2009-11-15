require 'rexml/document'
require 'rexml/xpath'

class Harness
  module REXML
    class XPath
      def perform(xml_input)
        doc = ::REXML::Document.new(xml_input)
        ::REXML::XPath.match(doc.root, "//atom:entry/atom:title/text()",
                             "atom" => "http://www.w3.org/2005/Atom").map{|e| e.value}
      end
    end
  end

  def self.parser
    Harness::REXML::XPath.new
  end
end
