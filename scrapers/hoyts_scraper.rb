#encoding: utf-8
require "open-uri"

module CinesApi
  class HoytsScraper
    def run
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

        unless theater = Theater.where(:name => name).first
          # Create it then.
          theater = Theater.create :name => name, :url => url, :lat => 0, :lng => 0
        else
          # Clear all the movies
          theater.movies.destroy_all
        end

        movie = {}

        doc.css('td div div td td td:nth-child(3) td:nth-child(1)').each do |movie_row|
          if title = movie_row.at_css('.titulos')
            # puts "Titulo: #{title.text}"
            movie[:name] = title.text
          else
            # puts "Horario: #{movie_row.text.strip}"
            movie[:showtimes] = movie_row.text.strip.split(/,?\s+/)

            Movie.create :name => movie[:name], :showtimes => movie[:showtimes], :theater => theater

            # Reset this hash
            movie = {}
          end
        end
      end
    end
  end
end