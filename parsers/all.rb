Dir[File.dirname(__FILE__) + '/**/*.rb'].each do |f|
  next if f =~ /parsers\/j/ && !defined?(JRUBY_VERSION)
  require f
end
