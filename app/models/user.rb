class User < ActiveRecord::Base
  include RatingAverage
  has_secure_password
  validates :username, uniqueness: true
  validates :username, length: { in: 3..30 }
  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/}

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships


  def favourite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favourite_style
    stylesRated = beers.group(:style).count.keys
    highestAvg = 0
    favStyle = nil

    stylesRated.each do |style|
      styleAvg = ratings.includes("beer").where(beers: {style_id: style}).average("ratings.score")
      if styleAvg > highestAvg
        highestAvg = styleAvg and favStyle = style
      end
    end

    return favStyle
  end



  def favourite_brewery
    breweriesRated = beers.group(:brewery).count.keys
    highestAvg = 0
    favBrewery = nil

    breweriesRated.each do |brewery|
      breweryAvg = ratings.includes("beer").where(beers: {brewery_id: brewery.id}).average("ratings.score")
      if breweryAvg > highestAvg
        highestAvg = breweryAvg and favBrewery = brewery
      end
    end
    return favBrewery
  end


end
