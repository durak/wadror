class Brewery < ActiveRecord::Base
  include RatingAverage
  validates :name, presence: true
  validate :year_check
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers


  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }
  scope :top, -> (n) { joins('LEFT JOIN "beers" ON "beers"."brewery_id" = "breweries"."id"')
                           .joins('LEFT JOIN "ratings" ON "ratings"."beer_id" = "beers"."id"')
                           .group('"breweries"."id"')
                           .order('AVG(ratings.score) DESC')
                           .first(n) }
=begin
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   less_than_or_equal_to: 2017,
                                   only_integer: true}
=end



  def year_check
    errors.add(:year, "year must be between 1042 and #{Time.now.year}") if
        year < 1042 or year > Time.now.year
  end


  def print_report
    puts name
    puts "established: #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

  def restart
    self.year = 2017
    puts "changeg year to #{self.year}"
  end

#  def average_rating
#    self.ratings.average(:score)
#  end
end
