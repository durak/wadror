class Style < ActiveRecord::Base
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :top, -> (n) { joins('LEFT JOIN "beers" ON "beers"."style_id" = "styles"."id"')
                           .joins('LEFT JOIN "ratings" ON "ratings"."beer_id" = "beers"."id"')
                           .group('"styles"."id"')
                           .order('AVG(ratings.score) DESC')
                           .first(n) }
end
