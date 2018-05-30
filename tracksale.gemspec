Gem::Specification.new do |s|
  s.name        = 'tracksale'
  s.version     = '0.0.1'
  s.licenses    = ['MIT']
  s.summary     = 'Integration gem for tracksale api v2'
  s.description = 'Integration gem for tracksale api v2'
  s.authors     = ['Estudar']
  s.email       = 'regis@estudar.org.br'
  s.files       = Dir['lib/*.rb']
  s.homepage    = 'https://github.com/estudar/tracksale'
  s.metadata    = { 'source_code_uri' =>
        'https://github.com/estudar/tracksale' }

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'webmock'

  s.add_dependency 'httparty'
end
