Dir[File.dirname(__FILE__) + '/**/*.rb'].each do |f|
  next if f =~ /bench\/j/ && !defined?(JRUBY_VERSION)
  require f
end
