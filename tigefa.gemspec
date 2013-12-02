Gem::Specification.new do |s|
  s.name        = 'tigefa'
  s.version     = '1.0.0'
  s.date        = '03-12-2013'
  s.rubyforge_project = 'tigefa'
  s.summary     = "tigefa gem provide cloud command like dropbox upload, google drive upload"
  s.description = "tigefa gem provide cloud command like dropbox upload, google drive upload"
  s.authors     = ["sugeng tigefa"]
  s.email       = 'sugeng.tigefa@gmail.com'
  s.files       = ["lib/tigefa.rb"]
  s.homepage    = 'https://github.com/tigefa4u/tigefa-gem'
  s.license     = 'MIT'
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.add_runtime_dependency('google_drive')
end
