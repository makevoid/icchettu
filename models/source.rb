require 'date'
# require 'mechanize'

class Source

  URL = "http://firenzenotte.it"

  def initialize
    @agent = Mechanize.new
  end

  def get
    events = []
    locations = []

    page = @agent.get URL
    main = page.search "#principale"

    evts = main.search ".home-evento-tit"
    for event in evts
      name = event.search(".summary").inner_text
      url = event.search("a").first["href"]
      date = Date.parse url.split("/")[-1]

      events << { name: name, source_url: url, date: date }
    end

    events.each do |event|
      page = @agent.get event[:source_url]
      category = page.search(".home-evento-cat-det a").first
      category = if category
        category.inner_text
      else
        page.search(".home-evento-cat-det").inner_text
      end

      description = page.search(".descrizione_evento").inner_html

      location_source_url = page.search(".tipologia h2 a").first
      location_source_url = location_source_url["href"] if location_source_url

      event.merge! category: category, description: description, location_source_url: location_source_url
      locations << { source_url: location_source_url } if location_source_url
    end

    locations.uniq!
    locations.each do |location|
      page = @agent.get location[:source_url]
      name = page.search(".titolo h1").inner_text
      address = page.search(".indirizzo-locale").inner_text
      description = page.search("#scheda_locale").inner_html

      location.merge! name: name, description: description, address: address
    end

    ###
    DataMapper.auto_migrate!

    no_location = Location.create name: "[empty]"

    locations.each do |loc|
      Location.create loc.strip_all
    end

    events.each do |evt|
      loc = if evt[:location_source_url]
        Location.first source_url: evt[:location_source_url]
      else
        no_location
      end

      evt.delete :location_source_url
      loc.events.create evt.strip_all
    end

  end
end


# Source.new.get