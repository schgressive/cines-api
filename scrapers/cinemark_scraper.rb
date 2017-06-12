#encoding: utf-8
require "open-uri"

module CinesApi
  class CinemarkScraper
    def run
      theaters = {
        # SANTIAGO
        "Alto las Condes" => "alto-las-condes",
        "Plaza Vespucio" => "vespucio",
        "Plaza Tobalaba" => "plaza-tobala",
        "Plaza Norte" => "plaza-norte",
        "Plaza Oeste" => "plaza-oeste",
        "Portal Ñuñoa" => "portal-nunoa",
        "Mid Mall Maipú" => "midmall"
        # REGIONES
        # "Espacio Urbano - Viña del Mar" => "vina-shopping",
        # "Iquique" => "DetalleCine.aspx?cinema=520",
        # "Rancagua" => "DetalleCine.aspx?cinema=517",
        # "Plaza Mirador Bio-Bio" => "PlazaMiradorBioBio.html",
        # "Plaza del Trébol" => "DetalleCine.aspx?cinema=548",
        # "Marina Arauco" => "DetalleCine.aspx?cinema=570",
        # "Plaza La Serena" => "DetalleCine.aspx?cinema=521",
      }

      theaters.each_pair do |name, identifier|
        url = "http://www.cinemark.cl/theatres/#{identifier}"
        doc = Nokogiri::HTML(open(url))

        unless theater = Theater.where(:name => name).first
          # Create it then.
          theater = Theater.create :name => name, :url => url#, :lat => 0, :lng => 0
        else
          # Clear all the movies
          theater.movies.destroy_all
        end

        doc.css('#theater-show-list .movie-list-li').each do |row|
          movie = Movie.new :theater => theater
          movie.name = row.at_css('.movie-list-detail h3 span').text.strip
          movie.image_url = row.at_css('img')["src"]
          movie.url = row.at_css('a')["href"]
          showtimes = []
          row.css('.showtime-items li').each do |showtime|
            showtimes << "#{showtime.css('.showtime-day').text} #{showtime.css('.showtime-hour').map { |e| e.text }.join(', ')}"
          end
          movie.showtimes = showtimes.join("_")
          movie.save
        end
      end
    end
  end
end