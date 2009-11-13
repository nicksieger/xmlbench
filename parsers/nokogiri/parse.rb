require 'nokogiri'

class Harness
  module Nokogiri
    class Parse
      def prepare_input(xml_string)
        xml_string
      end

      def perform(xml_input)
        ::Nokogiri.XML(xml_input)
      end
    end
  end

  def self.parser
    Harness::Nokogiri::Parse.new
  end
end
