Gem::Specification.new do |s|
  s.name        = 'tracksale'
  s.version     = '0.0.6'
  s.licenses    = ['MIT']
  s.summary     = 'Integration gem for tracksale api v2'
  s.description = 'Integration gem for tracksale api v2'
  s.authors     = ['Estudar']
  s.email       = 'regis@estudar.org.br'
  s.homepage    = 'https://github.com/estudar/tracksale'
  s.metadata    = { 'source_code_uri' =>
        'https://github.com/estudar/tracksale' }

  s.files         = `git ls-files -z`.split("\x0")
  s.test_files    = s.files.grep(%r{^test/})
  s.require_paths = ['lib']

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'webmock'

  s.add_dependency 'httparty'
end
