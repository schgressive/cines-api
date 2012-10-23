task :environment do
  require "./boot"
end

desc "Runs the development server (default)"
task :server do
  system "rackup"
end

desc "Runs the console"
task :console => :environment do
  require "irb"
  include CinesApi
  ARGV.clear
  IRB.start
end

task :s => :server
task :c => :console