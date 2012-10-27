#encoding: utf-8
require "open-uri"

module CinesApi
  class CinemarkScraper
    def movies
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

        # Construct the output hash for this theater
        theater = {
          :name => name,
          :url => url,
          :location => [0,0], # Should be [lat, lng]
          :movies => []
        }

        # Holds a movie's name temporarily
        movie = {}

        doc.css('#box_left .box_middle').each do |row|
          movie[:name] = row.at_css('.h18').text.strip
          movie[:showtimes] = row.at_css('table tr:first-child td:last-child').text.strip.split(/[\s\t\n\r]+/).keep_if do |showtime|
            showtime =~ /\d+:\d/
          end

          theater[:movies] << movie

          movie = {}
        end

        out_theaters << theater
      end

      out_theaters
    end
  end
end