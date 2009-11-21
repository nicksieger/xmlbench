These benchmarks were written for the article "XML Parsing in Ruby" on
the Engine Yard blog.

http://www.engineyard.com/blog/2009/xml-parsing-in-ruby/

## Usage

To use them, first ensure you have the Hpricot and Nokogiri gems
installed.

    gem install nokogiri hpricot

Benchmarks are run with Rake. To run a benchmark, run one of the
following:

- rake bench:all     Run all available benchmarks
- rake bench:<pkg>   Run one package's benchmarks (where <pkg> is the
                     name of one of the subdirectories in lib/xmlbench)
- rake bench BENCH=<file> Run one or more individual benchmarks.

Pass N=<iterations> on the command-line to change the number of iterations.

To add more data files, edit the Rakefile and change the `URLs` hash
at the top. Be aware that some of the benchmarks make assumptions
about the documents taking the form of an Atom document, so those
benchmarks may break or be invalid.

## Creating a new benchmark

A benchmark is an object responds to a method named
`#perform(xml_input)`. The input is an IO-like stream containing the
document to be parsed. A benchmark can also respond to a method named
`#prepare(xml_stream)`. The prepare method is called once before the
benchmark measurement and can be used to setup any state whose
creation shouldn't be included in the measurements.

Each benchmark should be in its own file and have an overload for the
Harness.parser factory method as follows:

    class Harness
      def self.parser
        MyParser.new
      end
    end

## Notes

If you're running benchmarks with JRuby, be aware of the following
issues:

- To run the Nokogiri benchmarks on JRuby, you need to enable
  objectspace (jruby -X+O; as of Nokogiri release 1.4)
- However, turning on objectspace slows down overall JRuby
  performance, so it's recommended to only enable it for Nokogiri.
- To run the jaxp/stream benchmark, you need Java 6 or higher or you
  need to manually download and install the StAX parser and APIs on
  your classpath.
