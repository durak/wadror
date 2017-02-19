require 'apixu'

class ApixuWeather

  def self.weather_in(city)
    client = Apixu::Client.new "#{key}"
    weather = client.current city

    return [] if weather.nil?

    weather = [ "name" => weather["location"]["name"], "temp" => weather["current"]["temp_c"], "text" => weather["current"]["condition"]["text"] ,"icon" => weather["current"]["condition"]["icon"] ].first
  end

  def self.key
    raise "APIXUKEY env variable not defined" if ENV['APIXUKEY'].nil?
    ENV['APIXUKEY']
  end
end