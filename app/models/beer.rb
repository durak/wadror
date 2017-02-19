class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

#  def average_rating
#    self.ratings.average(:score)
#  end

  def to_s
    self.brewery.name + ", " + self.name
  end
end
