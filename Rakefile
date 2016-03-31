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
    url_ignore: [/linkedin\.com/]
  ).run
end

task ci: %i(build test)
