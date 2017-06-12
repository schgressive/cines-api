module CinesApi
  class App < Sinatra::Base
    # This is a JSON API
    before { content_type :json, :charset => 'utf-8' }

    get '/theaters' do
      theaters = Theater.all
      theaters.map do |theater|
        {
          id: theater.id.to_s,
          name: theater.name,
          url: theater.url
        }
      end.to_json
    end

    get '/theaters/:id/movies' do
      unless theater = Theater.where(:id => params[:id]).first
        halt 404
      end

      json = JSONBuilder::Compiler.new
      json.array theater.movies do |movie|
        name movie.name
        image_url movie.image_url
        url movie.url
        showtimes movie.showtimes.split("_")
      end.to_s
    end

    post '/webhook' do
      #action = request.body.read.to_h
      puts params["result"]["action"]
      if params["result"]["action"] == "show_theaters"
        show_theaters
      elsif params["result"]["action"] == "see_movies"
        theater_name = params["result"]["parameters"]["theater_name"]
        puts theater_name.inspect
        show_movies theater_name
      else
        halt 404
      end
     
    end

    ##

    def show_theaters
       elements = []
      Theater.all.limit(10).each do |theater|
          elements << {
              "title": theater.name,
              "image_url": "http://www.logotypes101.com/logos/278/2BD38DC98A9956FB2D0BB0595FC5CE81/cinehoyts.png",
              #"subtitle": "Smurfette attempts to find her purpose in the village. When she encounters a creature in the Forbidden Forest who drops a mysterious map, she sets off with her friends Brainy, Clumsy, and Hefty on an adventure to find the Lost Village before the evil wizard Gargamel does.",
              "default_action": {
                  "type": "web_url",
                  "url": theater.url,
                  "webview_height_ratio": "tall"
              },
              "buttons": [
                  {
                      "title": "Ver Cartelera",
                      "type": "postback",
                      "payload": "Ver Cartelera de #{theater.name}",
                  },
                 {
                      "title": "Pagina Web",
                      "type": "web_url",
                      "url": theater.url,
                      "webview_height_ratio": "tall"
                  }
              ]
            }
      end
      speech = "Te muestro un listado de los cines disponibles..."
      {
        "speech": speech,
        "source": "show_theaters",
        "displayText": speech,
        "data": {
          "facebook": {
            "attachment": {
              "type": "template",
              "payload": {
                  "template_type": "generic",
                  "elements": elements
              }
            }
          }
        }
      }.to_json
    end

    def show_movies theater_name
      #theater = Theater.where(:name => theater_name).first
      theater = Theater.where(name: /^#{theater_name}/i).first
      return halt 404 if theater.nil?
      elements = []
      theater.movies.limit(10).each do |movie|
        puts movie.name
        elements << {
            "title": movie.name,
            "image_url": movie.image_url,
            "subtitle": "Cartelera de #{theater.name}",
            "default_action": {
                "type": "web_url",
                "url": theater.url,
                "webview_height_ratio": "tall"
            },
            "buttons": [
                {
                    "title": "Ver Horarios",
                    "type": "postback",
                    "payload": "Ver Cartelera de #{theater.name}",
                },
               {
                    "title": "Ver más",
                    "type": "web_url",
                    "url": movie.url,
                    "webview_height_ratio": "tall"
                }
            ]
          }
      end
      speech = "Te muestro la cartelera..."
      {
        "speech": speech,
        "source": "see_movies",
        "displayText": speech,
        "data": {
          "facebook": {
            "attachment": {
              "type": "template",
              "payload": {
                  "template_type": "generic",
                  "elements": elements
              }
            }
          }
        }
      }.to_json
    end

  end
end
