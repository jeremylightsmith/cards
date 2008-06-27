ENV["FILE"] ||= "/Users/jeremy/Desktop/PunchList Master Story List/Card Wall-Card Wall.csv"

require 'rubygems'
gem "rspec"
gem "hoe"

require 'rake/clean'
require 'spec/rake/spectask'
require 'hoe'

require 'lib/cards'

desc "Default Task"
task :default => [:spec]

task :test => :spec

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "export to dot file"
task :run_dot do
  file = ENV["FILE"] || SAMPLE_FILE
  file.as(:png).delete_if_exists
  file.as(:dot).delete_if_exists

  CardWall.convert(file, :dot, file.as(:dot))

  "dot -Tpng #{file.as(:dot).no_spaces} > #{file.as(:png).no_spaces}".run
  "open #{file.as(:png).no_spaces}".run if file.as(:png).exists?
end

desc "export to text"
task :run_text do
  CardWall.convert(ENV["FILE"] || SAMPLE_FILE, :text)
end

desc "export to graffle"
task :run do
  file = ENV["FILE"] || SAMPLE_FILE
  file.as(:graffle).delete_if_exists

  CardWall.convert(file, :graffle, file.as(:graffle))
end

Hoe.new('cards', Cards::VERSION) do |p|
  p.rubyforge_name = 'cardwallgen'
  p.summary = p.description = p.paragraphs_of('README.txt', 2).first
  p.url = p.paragraphs_of('README.txt', -1).first.strip
  p.author = 'Jeremy Stell-Smith'
  p.email = 'jeremystellsmith@gmail.com'
  p.changes = p.paragraphs_of('CHANGES.txt', 0..2).join("\n\n")
end
