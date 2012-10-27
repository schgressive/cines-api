module CinesApi
  class App < Sinatra::Base
    # This is a JSON API
    before { content_type :json }

    get '/theaters' do
      theaters = Theater.all

      json = JSONBuilder::Compiler.new
      json.array theaters do |theater|
        id   theater.id
        name theater.name
        lat  theater.lat
        lng  theater.lng
      end.to_s
    end

    get '/theaters/:id/movies' do
      unless theater = Theater.where(:id => params[:id]).first
        halt 404
      end

      json = JSONBuilder::Compiler.new
      json.array theater.movies do |movie|
        name movie.name
        showtimes movie.showtimes.split(' ')
      end.to_s
    end
  end
end
