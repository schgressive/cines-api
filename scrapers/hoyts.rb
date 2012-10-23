#encoding: utf-8
require "open-uri"

module CinesApi
  class HoytsScraper
    def movies
      theaters = {
        "La Reina"         => "reina",
        "Parque Arauco"    => "par",
        "San Agustín"      => "sagustin",
        "Estación Central" => "ecentral",
        "Arauco Maipú"     => "maipu",
        "Puente Alto"      => "palto",
        # "Melipilla"        => "melipilla",
        "Valparaíso"       => "valpo"
      }

      out_theaters = []

      theaters.each_pair do |name, identifier|
        url = "http://www.cinehoyts.cl/?mod=#{identifier}"
        doc = Nokogiri::HTML(open(url))

        # Construct the output hash for this theater
        theater = {
          :name => name,
          :url => url,
          :location => [0,0], # Should be [lat, lng]
          :movies => []
        }

        # Holds a movie's name temporarily
        movie = {}

        doc.css('td div div td td td:nth-child(3) td:nth-child(1)').each do |movie_row|
          if title = movie_row.at_css('.titulos')
            # puts "Titulo: #{title.text}"
            movie[:name] = title.text
          else
            # puts "Horario: #{movie_row.text.strip}"
            movie[:showtimes] = movie_row.text.strip.split(/,?\s+/)
            theater[:movies] << movie

            # Reset this hash
            movie = {}
          end
        end

        out_theaters << theater
      end

      out_theaters
    end
  end
end