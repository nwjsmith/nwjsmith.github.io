# frozen_string_literal: true

require 'jekyll'
require 'html-proofer'

desc 'Build the site'
task :build do
  Jekyll::Commands::Build.process({})
end

desc 'Test the site'
task test: :build do
  HTMLProofer.check_directory(
    '_site/',
    check_favicon: true,
    check_html: true,
    typhoeus: {
      headers: { 'User-Agent' => 'Mozilla/5.0 (compatible; HTMLProofer)' }
    }
  ).run
end

task ci: %i(build test)
