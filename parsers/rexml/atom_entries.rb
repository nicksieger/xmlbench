require 'rexml/document'
require 'rexml/xpath'

class Harness
  module REXML
    class AtomEntries
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        doc = ::REXML::Document.new(xml_input)
        ::REXML::XPath.match(doc.root, "//atom:entry/atom:title/text()",
                             "atom" => "http://www.w3.org/2005/Atom").map{|e| e.value}
      end
    end
  end

  def self.parser
    Harness::REXML::AtomEntries.new
  end
end
