require 'nokogiri'

class Harness
  module Nokogiri
    class Parse
      def perform(xml_input)
        ::Nokogiri.XML(xml_input)
      end
    end
  end

  def self.parser
    Harness::Nokogiri::Parse.new
  end
end
