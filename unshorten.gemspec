Gem::Specification.new do |s|
    s.name = 'unshorten'
    s.version = '0.1.2'
    s.date = '2011-12-10'
    s.summary = 'Unshorten URLs'
    s.description = 'Get original URLs from shortened ones'
    s.authors = ["Wu Jun"]
    s.email = 'quark@lihdd.net'
    s.homepage = 'https://github.com/quark-zju/unshorten'
    s.require_paths = ['lib']
    s.files = Dir['lib/*{,/*}']
    s.test_files = Dir['test/*']
    s.executables = ['unshorten']
end
