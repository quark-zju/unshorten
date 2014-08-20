Gem::Specification.new do |s|
  s.name = 'unshorten'
  s.version = '0.3.0'
  s.license = 'BSD'
  s.date = Date.civil(2014, 3, 9)
  s.summary = 'Unshorten URLs'
  s.description = 'Get original URLs from shortened ones'
  s.authors = ["Jun Wu"]
  s.email = 'quark@lihdd.net'
  s.homepage = 'https://github.com/quark-zju/unshorten'
  s.require_paths = ['lib']
  s.files = Dir['lib/*{,/*}']
  s.test_files = Dir['test/*']
  s.executables = ['unshorten']
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
end
