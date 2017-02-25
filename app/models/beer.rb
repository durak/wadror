class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, presence: true
  validates :style_id, presence: true

  scope :top, -> (n) { joins('LEFT JOIN "ratings" ON "ratings"."beer_id" = "beers"."id"')
                           .group('beer_id')
                           .order('AVG(ratings.score) DESC')
                           .first(n) }


  def to_s
    self.brewery.name + ", " + self.name
  end
end
