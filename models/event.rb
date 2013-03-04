# require_relative "source"

class Event
  include DataMapper::Resource

  CATEGORIES = ["Aperitivo", "Cena", "Bere Qualcosa", "Teatro", "Ballare", "Festa", "Cinema", "Altro"]
  SOURCES = [:firenzenotte] # :nottefiorentina

  property :id, Serial
  property :name, String, length: 255
  property :name_url, String, length: 255
  property :date, Date
  # property :end_time, DateTime
  property :source, Enum[*SOURCES], default: :firenzenotte
  property :source_url, String, length: 255
  property :category_id, Integer
  # property :fb_link, String
  property :description, Text

  belongs_to :location

  before :create do
    self.name_url = name.urlify
  end

  def category
    CATEGORIES.fetch category_id
  end

  def category=(name)
    CATEGORIES.index name
  end

end