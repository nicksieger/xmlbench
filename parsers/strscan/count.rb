require 'strscan'

class Harness
  module Strscan
    class Count
      def prepare_input(xml_string)
        xml_string
      end

      def perform(xml_input)
        count = 0
        s = StringScanner.new(xml_input)
        while s.scan_until(/<[^\/]/)
          count += 1
        end
        count
      end
    end
  end

  def self.parser
    Harness::Strscan::Count.new
  end
end
