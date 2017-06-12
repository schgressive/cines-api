$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler"

Bundler.require

require 'rack'

require 'rack/contrib'

require "sinatra/base"

require "models/movie"
require "models/theater"

require "scrapers/hoyts_scraper"
require "scrapers/cinemark_scraper"

require "app"

# Set up the database
Mongoid.load!("./config/mongoid.yml", Sinatra::Base.settings.environment)