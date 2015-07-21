# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3_sync/version'

Gem::Specification.new do |spec|
  spec.name          = "s3_sync"
  spec.version       = S3Sync::VERSION
  spec.authors       = ["MJ Rossetti (@s2t2)"]
  spec.email         = ["s2t2mail+git@gmail.com"]

  spec.summary       = %q{Securely sync (upload and download) files with Amazon Simple Storage Service (s3).}
  spec.description   = %q{Securely sync (upload and download) files with Amazon Simple Storage Service (s3). Specify credentials, file names, and other options during configuration.}

  spec.homepage      = "https://github.com/s2t2/s3-sync-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  ### if spec.respond_to?(:metadata)
  ###   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  ### else
  ###   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  ### end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_dependency 'aws-sdk', '~> 2'
  spec.add_dependency 'encryptor'
end
