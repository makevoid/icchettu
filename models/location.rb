# require_relative "event"

class Location
  include DataMapper::Resource

  property :id, Serial
  property :name, String, length: 255
  property :name_url, String, length: 255
  property :address, Text, length: 255
  property :lat, Float
  property :lng, Float
  # property :fb_link, String
  property :source_url, String, length: 255
  property :description, Text

  has n, :events

  before :create do
    self.name_url = name.urlify
  end

end