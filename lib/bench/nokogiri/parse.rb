require 'nokogiri'

class Harness
  module Nokogiri
    class Parse
      def prepare_input(xml_stream)
        xml_stream
      end

      def perform(xml_input)
        xml_input.rewind if xml_input.respond_to?(:rewind)
        ::Nokogiri.XML(xml_input)
      end
    end
  end

  def self.parser
    Harness::Nokogiri::Parse.new
  end
end
