class BeermappingApi

  def self.places_in(city)
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


  def self.key
    "c26f09f78295afae559113277da0ebcc"
  end
end