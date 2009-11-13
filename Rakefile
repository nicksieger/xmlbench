
URLs = {
  "data/google-news.xml" => "http://news.google.com/?output=atom",
  "data/twitter-search.xml" => "http://search.twitter.com/search.atom?lang=en&q=xml&rpp=100",
# Leave out Twitter timeline for now, as we can build benchmarks
# around assumption of atom-formatted documents
#   "data/twitter-timeline.xml" => "http://twitter.com/statuses/public_timeline.xml"
}

require './harness/harness'
$LOAD_PATH << "./parsers"

directory "data"

rule ".xml" => "data" do |t|
  fail "Don't know URL where I can fetch #{t.name}!" unless URLs[t.name]
  require 'net/http'
  url = URI.parse(URLs[t.name])
  puts "fetching #{url}..."
  res = Net::HTTP.start(url.host, url.port) do |http|
    http.get(url.request_uri)
  end
  res.error! unless Net::HTTPSuccess === res
  File.open(t.name, "w") do |f|
    f << res.body
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
task :check_data => URLs.keys do
end

namespace :bench do
  def run_file(f)
    Harness.run_parser(f =~ %r{parsers/(.*)\.rb} && $1, URLs.keys.sort, ENV['N'] && ENV['N'].to_i)
  rescue => e
    puts e.message
    if e.message =~ /objectspace/
      check_objectspace
    else
      raise
    end
  end

  desc "Run the benchmarks on all parsers."
  task :all => :check_data do
    FileList['parsers/**/*.rb'].each {|f| run_file(f) }
  end

  Dir['parsers/*'].each do |dir|
    if File.directory?(dir)
      basename = File.basename(dir)
      desc "Run the #{basename} parser benchmarks."
      task basename => :check_data do
        FileList["#{dir}/**/*.rb"].each {|f| run_file(f) }
      end
    end
  end
end

task :bench => :check_data do
  fail "specify parser with PARSERS=parsers/somefile.rb" unless ENV["PARSERS"]
  FileList[*(ENV["PARSERS"].split(/\s*,\s*/))].each {|f| run_file(f) }
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
