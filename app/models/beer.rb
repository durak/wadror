class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery
  has_many :ratings, dependent: :destroy

#  def average_rating
#    self.ratings.average(:score)
#  end

  def to_s
    self.brewery.name + ", " + self.name
  end
end
