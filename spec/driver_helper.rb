require 'stringio'
class StringIO
  include ToByteArrayInputStream if defined?(ToByteArrayInputStream)
end

module DriverHelper
  FIXTURE = File.dirname(__FILE__) + '/fixtures/google-news.xml'
  FIXTURE_CONTENTS = File.read(FIXTURE)

  def included(base)
    base.after :each do
      @stream.close if @stream
    end
  end

  def xml_content
    FIXTURE_CONTENTS
  end

  def xml_stream
    unless @stream
      @stream = File.new(FIXTURE)
    end
    @stream
  end

  class SpecDriver < Harness::Driver
    def initialize(parser)
      super(parser.to_s, parser)
    end
    def prepare
      super(StringIO.new(FIXTURE_CONTENTS))
    end
  end

  def create_driver(klass = nil)
    driver = SpecDriver.new((klass || description_args.first).new)
    driver.prepare
    driver
  end

  class ShouldParseTheSameAs
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target = target
      exp = SpecDriver.new(@expected.new)
      tgt = SpecDriver.new(@target.new)
      exp.prepare ; tgt.prepare
      @expected_value = exp.run
      @target_value   = tgt.run
      @expected_value == @target_value
    end

    def failure_message
      "expected:\n#{@target_value.inspect} (#{@target_value.class})\nto be " +
        "the same as:\n#{@expected_value.inspect} (#{@expected_value.class})"
    end

    def negative_failure_message
      "expected:\n#{@target_value.inspect} (#{@target_value.class})\nnot to be " +
        "the same as:\n#{@expected_value.inspect} (#{@expected_value.class})"
    end
  end

  def parse_the_same_as(expected)
    ShouldParseTheSameAs.new(expected)
  end

  class ShouldBeAnArrayOfStrings
    def matches?(target)
      @target = target
      Array === target && target.size > 0 && target.all? {|x| String === x}
    end

    def failure_message
      "#{@target.inspect} should be an array of strings"
    end

    def negative_failure_message
      "#{@target.inspect} should not be an array of strings"
    end
  end

  def be_an_array_of_strings
    ShouldBeAnArrayOfStrings.new
  end
end

module DriverExtender
  def it_should_parse_the_same_as(expected)
    klass = description_args.first
    it "should parse the same as #{expected.to_s}" do
      klass.should parse_the_same_as(expected)
    end
  end
end
