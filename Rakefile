
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

desc "Fetch new data"
task :fetch_data => URLs.keys

namespace :bench do
  def run_file(f)
    Harness.run_parser(f =~ %r{parsers/(.*)\.rb} && $1, URLs.keys.sort, ENV['N'] && ENV['N'].to_i)
  end

  desc "Run the benchmarks on all parsers."
  task :all => :fetch_data do
    FileList['parsers/**/*.rb'].each {|f| run_file(f) }
  end

  Dir['parsers/*'].each do |dir|
    if File.directory?(dir)
      basename = File.basename(dir)
      desc "Run the #{basename} parser benchmarks."
      task basename => :fetch_data do
        FileList["#{dir}/**/*.rb"].each {|f| run_file(f) }
      end
    end
  end
end

task :bench do
  fail "specify parser with PARSERS=parsers/somefile.rb" unless ENV["PARSERS"]
  FileList[ENV["PARSERS"]].each {|f| run_file(f) }
end

task :default do
  puts "XML Parser benchmarks. Available tasks:"
  Rake.application.options.show_tasks = true
  Rake.application.options.full_description = false
  Rake.application.options.show_task_pattern = //
  Rake.application.display_tasks_and_comments
end
