require File.expand_path('../lib/bipbip/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'bipbip'
  s.version = Bipbip::VERSION
  s.summary = 'Gather services data and store in CopperEgg'
  s.description = 'Agent to collect data for common server programs and push them to CopperEgg'
  s.authors = ['Cargo Media', 'kris-lab', 'njam']
  s.email = 'hello@cargomedia.ch'
  s.files = Dir['LICENSE*', 'README*', '{bin,lib,data}/**/*']
  s.executables = ['bipbip']
  s.homepage = 'https://github.com/cargomedia/bipbip'
  s.license = 'MIT'

  s.add_runtime_dependency 'copperegg-revealmetrics', '~> 0.8.1'
  s.add_runtime_dependency 'memcached', '~> 1.8.0'
  s.add_runtime_dependency 'mysql2', '~> 0.3.18'
  s.add_runtime_dependency 'redis', '~> 3.2.1'
  s.add_runtime_dependency 'gearman-ruby', '~> 3.0.7'
  s.add_runtime_dependency 'resque', '~> 1.25'
  s.add_runtime_dependency 'monit', '~> 0.3'
  s.add_runtime_dependency 'mongo', '~> 2.0.5'
  s.add_runtime_dependency 'bson', '~> 3.0.3'
  s.add_runtime_dependency 'rb-inotify', '~> 0.9.5'
  s.add_runtime_dependency 'elasticsearch', '~> 1.0.6'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'webmock', '~> 1.21'
end
