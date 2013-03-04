class Icchettu < Sinatra::Base
  get "/" do
    @events_days = Event.all.group_by{ |a| a.date }

    haml :index
  end

  get "/events/*/*/*/*" do |year, month, day, name_url|
    date = Date.new year.to_i, month.to_i, day.to_i
    @event = Event.first name_url: name_url, date: date
    haml :event
  end

  get "/locations/*" do |name_url|
    @location = Location.first name_url: name_url
    haml :location
  end
end