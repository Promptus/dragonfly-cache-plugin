# frozen_string_literal: true

require_relative "lib/dragonfly/plugin/cache/version"

Gem::Specification.new do |spec|
  spec.name          = "dragonfly-cache-plugin"
  spec.version       = Dragonfly::Plugin::Cache::VERSION
  spec.authors       = ["Lars Kuhnt"]
  spec.email         = ["lars.kuhnt@gmail.com"]

  spec.summary       = "A local file cache plugin for dragonfly."
  spec.description   = "A simple local file cache plugin for the dragonfly image processing gem."
  spec.homepage      = "https://www.github.com/Promptus/dragonfly-cache-plugin"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/Promptus/dragonfly-cache-plugin"
  spec.metadata["changelog_uri"] = "https://www.github.com/Promptus/dragonfly-cache-plugin/CHANGELOG"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "dragonfly", "~> 1.3"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
