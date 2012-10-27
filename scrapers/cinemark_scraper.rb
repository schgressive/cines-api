#encoding: utf-8
require "open-uri"

module CinesApi
  class CinemarkScraper
    def run
      theaters = {
        "Alto las Condes" => "DetalleCine.aspx?cinema=512",
        "Plaza Oeste" => "DetalleCine.aspx?cinema=513",
        "Plaza Norte" => "DetalleCine.aspx?cinema=572",
        "Espacio Urbano" => "DetalleCine.aspx?cinema=514",
        "Iquique" => "DetalleCine.aspx?cinema=520",
        "Rancagua" => "DetalleCine.aspx?cinema=517",
        "Plaza Mirador Bio-Bio" => "PlazaMiradorBioBio.html",
        "Plaza Vespucio" => "DetalleCine.aspx?cinema=511",
        "Plaza Tobalaba" => "DetalleCine.aspx?cinema=519",
        "Plaza del Trébol" => "DetalleCine.aspx?cinema=548",
        "Marina Arauco" => "DetalleCine.aspx?cinema=570",
        "Plaza La Serena" => "DetalleCine.aspx?cinema=521",
        "Portal Ñuñoa" => "DetalleCine.aspx?cinema=2300"
      }

      out_theaters = []

      theaters.each_pair do |name, identifier|
        url = "http://www.cinemark.cl/#{identifier}"
        doc = Nokogiri::HTML(open(url))

        unless theater = Theater.where(:name => name).first
          # Create it then.
          theater = Theater.create :name => name, :url => url, :lat => 0, :lng => 0
        else
          # Clear all the movies
          theater.movies.destroy_all
        end

        # Holds a movie's name temporarily
        movie = {}

        doc.css('#box_left .box_middle').each do |row|
          movie = Movie.new :theater => theater

          movie.name = row.at_css('.h18').text.strip
          movie.showtimes = row.at_css('table tr:first-child td:last-child').text.strip.split(/[\s\t\n\r]+/).keep_if do |showtime|
            showtime =~ /\d+:\d/
          end.join(' ')

          movie.save
        end
      end
    end
  end
end