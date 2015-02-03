require File.expand_path("../lib/pat/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'pat'
  gem.version = Pat::VERSION

  gem.summary = "A safe list deconstructor"
  gem.description = "Deconstruct list fragments using pattern matching syntax"

  gem.authors  = ['Bob Long']
  gem.email    = 'robertjflong@gmail.com'
  gem.homepage = 'http://github.com/bobjflong/pat'

  gem.require_path = 'lib'

  gem.add_dependency('rake')
  gem.add_dependency('whittle')
  gem.add_dependency('ribimaybe')
  gem.add_development_dependency('rspec', [">= 2.0.0"])
  gem.add_development_dependency('fuubar')
  gem.add_development_dependency('readygo')

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', 'lib/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
end
