
URLs = {
#   "data/google-news.xml" => "http://news.google.com/?output=atom",
  "data/twitter-search.xml" => "http://search.twitter.com/search.atom?lang=en&q=xml&rpp=100",
# Leave out Twitter timeline for now, as we can build benchmarks
# around assumption of atom-formatted documents
#   "data/twitter-timeline.xml" => "http://twitter.com/statuses/public_timeline.xml"
}

$LOAD_PATH << "./lib"
require 'xmlbench/harness'
require 'open-uri'

directory "data"

rule ".xml" => "data" do |t|
  fail "Don't know URL where I can fetch #{t.name}!" unless URLs[t.name]
  File.open(t.name, "w") do |f|
    open(URLs[t.name]) do |url|
      f << url.read
    end
  end
end

desc "Clean cached data and any output files"
task :clean do
  rm_f URLs.keys
end

def check_objectspace
  if defined?(JRUBY_VERSION)
    require 'jruby'
    fail "Re-run JRuby with -X+O to enable ObjectSpace (needed for Nokogiri)" unless JRuby.objectspace
  end
end

desc "Fetch new data"
task :check_data => URLs.keys

namespace :bench do
  def run_files(paths)
    parsers = paths.map {|f| f =~ %r{(xmlbench/.*)\.rb} && $1 }
    Harness.run_parsers(parsers, URLs.keys.sort, ENV['N'] && ENV['N'].to_i)
  rescue => e
    puts e.message
    if e.message =~ /undefined method/
      check_objectspace
    else
      raise
    end
  end

  desc "Run the benchmarks on all parsers."
  task :all => :check_data do
    run_files(FileList['lib/xmlbench/**/*.rb'])
  end

  Dir['lib/xmlbench/*'].each do |dir|
    if File.directory?(dir)
      basename = File.basename(dir)
      desc "Run the #{basename} parser benchmarks."
      task basename => :check_data do
        run_files(FileList["#{dir}/**/*.rb"])
      end
    end
  end
end

task :bench => :check_data do
  fail "specify parser with PARSERS=lib/xmlbench/somefile.rb" unless ENV["BENCH"]
  run_files(FileList[*(ENV["BENCH"].split(/\s*,\s*/))])
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new do |t|
  t.ruby_opts = ['-rubygems']
  t.ruby_opts.unshift "-X+O" if defined?(JRUBY_VERSION) # enable objectspace; needed for nokogiri
  t.spec_files = FileList["spec/**/*_spec.rb"]
end

task :default do
  puts "XML Parser benchmarks. Available tasks:"
  Rake.application.options.show_tasks = true
  Rake.application.options.full_description = false
  Rake.application.options.show_task_pattern = //
  Rake.application.display_tasks_and_comments
end
