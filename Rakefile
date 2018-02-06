require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "gem_publisher"

RSpec::Core::RakeTask.new(:spec)

task default: %i(spec lint)

desc "Publish gem to RubyGems"
task :publish_gem do |_t|
  published_gem = GemPublisher.publish_if_updated("govuk_navigation_helpers.gemspec", :rubygems)
  puts "Published #{published_gem}" if published_gem
end

desc "Run govuk-lint with similar params to CI"
task "lint" do
  sh "bundle exec govuk-lint-ruby --format clang"
end
