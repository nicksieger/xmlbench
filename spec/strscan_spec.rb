require File.dirname(__FILE__) + '/spec_helper'

describe Harness::Strscan::Count do
  it_should_parse_the_same_as(Harness::REXML::Count)
end
