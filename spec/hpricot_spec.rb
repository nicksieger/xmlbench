require File.dirname(__FILE__) + '/spec_helper'

describe Harness::Hpricot::Count do
  it_should_parse_the_same_as(Harness::REXML::Count)
end

describe Harness::Hpricot::XPath do
  it_should_parse_the_same_as(Harness::REXML::XPath)
end

describe Hpricot do
  it "should parse the titles out of an Atom document" do
    document = Hpricot.XML(xml_content)
    elements = document.search("//entry/title/text()")
    titles = elements.map {|el| el.to_s }

    titles.should be_an_array_of_strings
  end

  it "should parse the titles out of a stream" do
    document = Hpricot.XML(xml_stream)
    elements = document.search("//entry/title/text()")
    titles = elements.map {|el| el.to_s }

    titles.should be_an_array_of_strings
  end

end
