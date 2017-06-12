module CinesApi
  class Theater
    include Mongoid::Document

    field :name, :type => String
    field :url, :type => String
    field :theater_identifier, :type => String
    field :lat, :type => Integer
    field :lng, :type => Integer

    has_many :movies
  end
end
