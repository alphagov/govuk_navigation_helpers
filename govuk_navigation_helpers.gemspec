# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'govuk_navigation_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = "govuk_navigation_helpers"
  spec.version       = GovukNavigationHelpers::VERSION
  spec.authors       = ["GOV.UK Dev"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]
  spec.summary       = "Gem to transform items from the content-store into payloads for GOV.UK components"
  spec.description   = "Gem to transform items from the content-store into payloads for GOV.UK components"
  spec.homepage      = "https://github.com/alphagov/govuk_navigation_helpers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "gem_publisher", "~> 1.5.0"

  spec.required_ruby_version = ">= 2.3.1"
end
