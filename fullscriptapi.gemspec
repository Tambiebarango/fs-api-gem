require_relative 'lib/fullscriptapi/version'

Gem::Specification.new do |spec|
  spec.name          = "fuelscropt-api-client"
  spec.version       = Fullscriptapi::VERSION
  spec.authors       = ["Theodore Ambie-Barango"]
  spec.email         = ["theodore.ambiebarango@fullscript.com"]

  spec.summary       = %q{This gem is designed to help consumers of the Fullscript API to be able to easily complete their builds.}
  spec.description   = %q{This gem is designed to help consumers of the Fullscript API to be able to easily complete their builds.}
  spec.homepage      = "https://github.com/Tambiebarango/fs-api-gem"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Tambiebarango/fs-api-gem"
  spec.metadata["changelog_uri"] = "https://github.com/Tambiebarango/fs-api-gem"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_development_dependency 'excon', '~> 0.85.0'
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
