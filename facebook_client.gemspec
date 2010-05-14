Gem::Specification.new do |s|
  s.name = %q{facebook_client}
  s.version = File.read('VERSION')
  s.authors = ["David Crockett"]
  s.date = %q{2010-05-13}
  s.description = %q{Facebook Client}
  s.email = %q{davy@davcro.com}
  s.files = Dir['lib/**/*.rb']
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Facebook Client}
  
  s.add_dependency 'faraday', '0.4.5'
  s.add_dependency 'yajl-ruby', '0.7.6'
  s.add_dependency 'rack', '1.0.1'
end