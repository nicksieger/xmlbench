require File.dirname(__FILE__) + '/spec_helper'
require 'rexml/parsers/pullparser'

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

  it "should walk the DOM to find the titles" do
    document = REXML::Document.new(xml_stream)
    titles = []
    document.root.each_recursive do |elem|
      titles << elem.text.to_s if elem.name == "title"
    end

    titles.should be_an_array_of_strings
  end

  it "should grab titles by pull parsing" do
    parser = REXML::Parsers::PullParser.new(xml_stream)
    titles = []
    text = ''
    grab_text = false
    parser.each do |event|
      case event.event_type
      when :start_element
        grab_text = true if event[0] == "title"
      when :text
        text << event[1] if grab_text
      when :end_element
        if event[0] == "title"
          titles << text
          text = ''
          grab_text = false
        end
      end
    end

    titles.should be_an_array_of_strings
  end
end
