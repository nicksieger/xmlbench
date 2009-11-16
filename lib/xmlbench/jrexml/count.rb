if defined?(JRUBY_VERSION)
  require 'jrexml'
  load File.dirname(__FILE__) + '/../rexml/count.rb'
else
  class Harness
    def self.parser
    end
  end
end
