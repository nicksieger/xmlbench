if defined?(JRUBY_VERSION)
  require 'jrexml'
  load File.dirname(__FILE__) + '/../rexml/parse.rb'
else
  class Harness
    def self.parser
    end
  end
end
