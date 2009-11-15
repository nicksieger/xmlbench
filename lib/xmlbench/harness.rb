require 'benchmark'

class Harness
  module Parser
    # Convert a Ruby stream into a possibly more efficient
    # representation for parsing. For example, Java XML parsers are
    # more likley to work with Java input streams or Java strings. The
    # benchmark is for measuring parsing speed, not input conversion
    # speed.
    def prepare_input(xml_string)
      xml_string
    end

    # Perform the benchmark. Parse the XML input as created by
    # #prepare_input and return the document or object representation,
    # when applicable. The result will be handed to XPathSearch#search
    # when performing the xpath search benchmark.
    def perform(xml_input)
    end
  end

  class Driver
    attr_reader :label
    def initialize(label, parser)
      @label = label
      if @label =~ /bench\/(.*)/
        @label = $1
      end
      @parser = parser
    end

    def prepare(arg)
      @input = @parser.prepare_input(arg)
    end

    def run
      @parser.perform(@input)
    end
  end

  # Default number of iterations.
  DEFAULT_ITERATIONS = 100

  def initialize(drivers, num_iterations)
    @drivers = drivers
    @num_iterations = num_iterations
  end

  def run_bench(*args)
    Benchmark.bmbm do |x|
      @drivers.each do |driver|
        args.each do |arg|
          begin
            driver.prepare(arg)
            x.report(driver.label + ": " + arg.path) { @num_iterations.times { driver.run } }
          rescue => e
            puts e.message, *e.backtrace
          end
        end
      end
    end
  end

  # Redefine this method in specific parser code to create a parser.
  #
  #     class Harness
  #       def self.parser
  #         # bootstrap your parser instance here that includes
  #         # or duck-types Harness::Parser
  #       end
  #     end
  def self.parser
  end

  def self.create_harness(parsers, num_iterations = nil)
    num_iterations ||= DEFAULT_ITERATIONS
    drivers = parsers.map do |parser_name|
      load "#{parser_name}.rb"
      parser
      if p = parser
        Driver.new(parser_name, p)
      else
        puts "Skipping #{parser_name}; no suitable driver available on this VM"
      end
    end.compact
    new(drivers, num_iterations)
  end

  # Run the parser 'n' times on the given list of files.
  def self.run_parsers(parsers, files, n)
    docs = files.map { |f| File.new(f) }
    harness = Harness.create_harness(parsers, n)
    harness.run_bench(*docs)
  ensure
    docs.each {|d| d.close rescue nil }
  end
end
