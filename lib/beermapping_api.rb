class BeermappingApi

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in:24.hours) { fetch_places_in(city) }
  end

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    # korvataan erikoismerkit URL-kelpoisiksi
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    # palautusarvo oli tyhjä hash, paikkakunnalta ei löytynyt ravintoloita
    return [] if places.is_a?(Hash) and places['id'].nil?

    # taulukkoon jos löytyi vain yksi ja palautui hashina
    places = [places] if places.is_a?(Hash)

    places.map do | place |
      Place.new(place)
    end
  end

  def self.place(city, id)
    places = places_in(city)
    places.select {|p| p.id == id}
  end


  def self.key
    raise "BEERAPIKEY env variable not defined" if ENV['BEERAPIKEY'].nil?
    ENV['BEERAPIKEY']
  end
end