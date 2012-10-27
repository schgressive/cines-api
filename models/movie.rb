module CinesApi
  class Movie
    include Mongoid::Document

    field :name, :type => String
    field :showtimes, :type => String # Just a space-separated string, easier

    belongs_to :theater
  end
end
