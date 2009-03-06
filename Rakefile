require 'rubygems'
gem "rspec"
gem "hoe"

require 'rake/clean'
require 'hoe'

require 'lib/cards'

desc "Default Task"
task :default => [:generate_manifest]

task :generate_manifest do
  File.open("Manifest.txt", "w") do |f|
    f << FileList["CHANGES.txt", "Rakefile", "README.txt", "examples/**/*", "lib/**/*", "spec/**/*"].to_a.join("\n")
  end
end

Hoe.new('cards', Cards::VERSION) do |p|
  p.rubyforge_name = 'cardwallgen'
  p.summary = p.description = p.paragraphs_of('README.txt', 2).first
  p.url = p.paragraphs_of('README.txt', -1).first.strip
  p.author = 'Jeremy Lightsmith'
  p.email = 'jeremy.lightsmith@gmail.com'
  p.changes = p.paragraphs_of('CHANGES.txt', 0..2).join("\n\n")
  p.extra_deps = ['rb-appscript','>= 0.5.1'], ['rest-client', '>= 0.9']
end
