require File.dirname(__FILE__) + '/spec_helper'

describe Harness::Nokogiri::Count do
  it_should_parse_the_same_as(Harness::REXML::Count)
end

describe Harness::Nokogiri::AtomEntries do
  it_should_parse_the_same_as(Harness::REXML::AtomEntries)
end

describe Nokogiri do
  it "should parse the titles in an Atom document" do
    document = Nokogiri.XML(xml_content)
    elements = document.xpath("//atom:entry/atom:title/text()",
                              "atom" => "http://www.w3.org/2005/Atom")
    titles = elements.map {|e| e.to_s}
    titles.should be_an_array_of_strings
  end

  it "should parse the titles out of a stream" do
    document = Nokogiri.XML(xml_stream)
    elements = document.xpath("//atom:entry/atom:title/text()",
                              "atom" => "http://www.w3.org/2005/Atom")
    titles = elements.map {|e| e.to_s}
    titles.should be_an_array_of_strings
  end
end
