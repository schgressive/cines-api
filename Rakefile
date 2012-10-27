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
  require "awesome_print"
  include CinesApi
  ARGV.clear
  IRB.start
end

desc "Runs all scrapers and updates the database"
task :update => :environment do
  print "Updating Cinemark..."
  CinesApi::CinemarkScraper.new.run
  puts "done"

  print "Updating Hoyts..."
  CinesApi::HoytsScraper.new.run
  puts "done"
end

task :s => :server
task :c => :console