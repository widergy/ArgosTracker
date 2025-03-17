# frozen_string_literal: true

require_relative 'lib/argos_tracker/version'

Gem::Specification.new do |spec|
  spec.name = 'argos_tracker'
  spec.version = ArgosTracker::VERSION
  spec.authors = ['mgonidev']
  spec.email = ['matiasgoni@live.com']

  spec.summary = 'A Ruby gem for tracking transactional events in Argos.'
  spec.description = 'This gem enables the transmission of events to Argos, providing greater traceability of user
  actions within the platform. It facilitates sending requests with event data, including request/response details,
  without affecting the existing functionality of the repositories where it is implemented. The gem supports flexible
  configuration, including API keys, headers, and data mapping. It is designed to work with multiple approaches,
  such as Singleton and RequestStore, ensuring efficiency and adaptability'
  spec.homepage = 'some_url'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "TODO: Put your gem's public repo URL here."
  spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rails', '~> 6.0'

  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop', '~> 1.21'
end
