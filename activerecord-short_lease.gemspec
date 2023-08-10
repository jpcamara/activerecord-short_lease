# frozen_string_literal: true

require_relative "lib/activerecord/short_lease/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-short_lease"
  spec.version = ActiveRecord::ShortLease::VERSION
  spec.authors = ["JP Camara"]
  spec.email = ["48120+jpcamara@users.noreply.github.com"]

  spec.summary = "Allow ActiveRecord to use explicit, short-lived connections"
  spec.description = "Allow ActiveRecord to use explicit, short-lived connections."
  spec.homepage = "https://github.com/jpcamara/activerecord-short_lease"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jpcamara/activerecord-short_lease"
  spec.metadata["changelog_uri"] = "https://github.com/jpcamara/activerecord-short_lease"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activerecord", "~> 7"
  spec.add_dependency "after_commit_everywhere", "~> 1.3"
  spec.add_development_dependency "sqlite3", "~> 1.3", ">= 1.3.6"
  spec.add_development_dependency "async", ">= 2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
