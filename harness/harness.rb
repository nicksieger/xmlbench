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
    attr_reader :label, :parser
    def initialize(label, parser)
      @label = label
      @parser = parser
    end

    def prepare(*args)
      @input = @parser.prepare_input(args[0])
    end

    def run
      @parser.perform(@input)
    end
  end

  # Default number of iterations.
  DEFAULT_ITERATIONS = 100

  def initialize(driver, num_iterations)
    @driver = driver
    @num_iterations = num_iterations
  end

  class BenchRun
    def initialize(iterations)
      @runs = []
      @iterations = iterations
    end
    def times(&block)
      @iterations.times do
        @runs << Benchmark.measure(&block)
      end
    end
    def sum
      @runs.inject(Benchmark::Tms.new) {|sum,x| sum += x }
    end
    def avg
      sum / @runs.size
    end
    def std
      mean = avg
      tms = @runs.inject(Benchmark::Tms.new) {|ssq,x| d = mean - x; ssq += d * d} / @runs.size
      tms = tms.to_a; tms.shift
      Benchmark::Tms.new(*(tms.map{|x| Math.sqrt(x)}))
    end
#     width = args.max {|a,b| a.name <=> b.name }.name.length + @driver.label.length + 7
#     extra_labels = args.map{|x| "#{@driver.label}: #{x.name}"}
#     extra_labels = extra_labels.map{|x| "#{x}>avg:"} + extra_labels.map{|x| "#{x}>std:"}
#     Benchmark.benchmark(" "*width + Benchmark::CAPTION, width, Benchmark::FMTSTR, *extra_labels) do |x|
  end

  def run_bench(*args)
    Benchmark.bmbm do |x|
      args.each do |arg|
        begin
          @driver.prepare(arg)
          x.report(@driver.label + ": " + arg.name) { @num_iterations.times { @driver.run } }
        rescue => e
          puts e.message, *e.backtrace
        end
      end
    end
  end

  def runnable?
    @driver.parser
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

  def self.create_harness(parser_name, num_iterations = DEFAULT_ITERATIONS)
    load "#{parser_name}.rb"
    driver = Driver.new(parser_name, parser)
    new(driver, num_iterations)
  end

  def self.run_parser(parser, files, n)
    docs = files.map do |f|
      contents = File.read(f)
      (class << contents; self; end).instance_eval do
        define_method(:name) { f }
      end
      contents
    end
    args = [parser]; args << n if n
    harness = Harness.create_harness(*args)
    if harness.runnable?
      puts "Running #{parser}"
      harness.run_bench(*docs)
    else
      puts "Skipping #{parser}; no suitable driver available on this VM"
    end
  end
end
