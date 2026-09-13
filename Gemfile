# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# Platform-specific dependencies
# nokogiri and libxml-ruby fail to compile on Windows ARM due to libxml2
# compilation issues, but work on other platforms
unless Gem.win_platform? && RUBY_PLATFORM.include?('aarch64')
  gem 'nokogiri'
  gem 'libxml-ruby'
end

gem 'leptris', '1.9.156.2'  # precompiled platform gems bundle libleptris (darwin/linux/mingw)
gem 'yeptris', '0.2.2.1'    # precompiled darwin/linux; no windows or darwin-intel gems yet
# teptris stays 0.1.0: 0.2.1's native ext links libruby by absolute build-runner
# path (loads only under exactly Ruby 3.3.12 at hostedtoolcache) and ships no
# mingw gems. Bump when the ext links portably and windows variants exist.
gem 'teptris', '0.1.0'
gem 'benchmark'  # Removed from stdlib in Ruby 4.0
gem 'base64'  # Required for Ruby 3.4+
gem 'lutaml-model', '~> 0.7'
gem 'octokit'
gem 'rake'
gem 'rspec'
gem 'rubocop'
gem 'rubocop-performance'
gem 'rubocop-rspec'
