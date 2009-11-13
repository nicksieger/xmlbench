require File.dirname(__FILE__) + '/spec_helper'

describe Harness::Nokogiri::Count do
  it_should_parse_the_same_as(Harness::REXML::Count)
end

describe Harness::Nokogiri::XPath do
  it_should_parse_the_same_as(Harness::REXML::XPath)
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

  it "should walk the DOM to find the titles" do
    document = Nokogiri::XML(xml_stream)
    titles = []
    document.root.traverse do |elem|
      titles << elem.content if elem.name == "title"
    end

    titles.should be_an_array_of_strings
  end

  it "should grab titles by pull parsing" do
    reader = Nokogiri::XML::Reader(xml_stream)
    titles = []
    text = ''
    grab_text = false
    reader.each do |elem|
      if elem.name == "title"
        if elem.node_type == 1  # start element?
          grab_text = true
        else # elem.node_type == 15  # end element?
          titles << text
          text = ''
          grab_text = false
        end
      elsif grab_text && elem.node_type == 3 # text?
        text << elem.value
      end
    end

    titles.should be_an_array_of_strings
  end
end
