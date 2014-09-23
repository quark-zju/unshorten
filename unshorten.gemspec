lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |s|
  s.name = 'unshorten'
  s.version = Unshorten::VERSION
  s.license = 'BSD'
  s.date = Date.civil(2014, 8, 20)
  s.summary = 'Unshorten URLs'
  s.description = 'Get original URLs from shortened ones'
  s.authors = ["Jun Wu"]
  s.email = 'quark@lihdd.net'
  s.homepage = 'https://github.com/quark-zju/unshorten'
  s.require_paths = ['lib']
  s.files = Dir['lib/*{,/*}']
  s.test_files = Dir['test/*']
  s.executables = ['unshorten']
  s.add_development_dependency 'minitest', '~> 5.3'
  s.add_development_dependency 'rake', '~> 10.1'
end
