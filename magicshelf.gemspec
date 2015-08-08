# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magicshelf/version'

Gem::Specification.new do |spec|
  spec.name          = "magicshelf"
  spec.version       = MagicShelf::VERSION
  spec.authors       = ["Shohei Fujii"]
  spec.email         = ["fujii.shohei@gmail.com"]

  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|sandbox|)/}) }
  spec.bindir        = "bin"
  spec.executables   = "magicconvert"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
  spec.add_development_dependency "pry-rescue"
  spec.add_development_dependency "shotgun"
  spec.add_development_dependency "foreman"
  spec.add_development_dependency "test-unit", "~> 3.1.2"

  spec.add_dependency "gepub"
  spec.add_dependency "resque"
  spec.add_dependency "ruby-filemagic"
  spec.add_dependency "rubyzip"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "naturally", '~> 1.4.0'
  spec.add_dependency "rmagick"
end
