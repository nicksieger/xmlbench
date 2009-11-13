require File.dirname(__FILE__) + '/spec_helper'


describe REXML do
  it "should parse the titles out of an Atom document" do
    document = REXML::Document.new(xml_content)
    elements = REXML::XPath.match(document.root, "//atom:entry/atom:title/text()",
                                  "atom" => "http://www.w3.org/2005/Atom")
    titles = elements.map {|e| e.value}

    titles.should be_an_array_of_strings
  end

  it "should parse the titles out of a stream" do
    document = REXML::Document.new(xml_stream)
    elements = REXML::XPath.match(document.root, "//atom:entry/atom:title/text()",
                                  "atom" => "http://www.w3.org/2005/Atom")
    titles = elements.map {|e| e.value}

    titles.should be_an_array_of_strings
  end
end
