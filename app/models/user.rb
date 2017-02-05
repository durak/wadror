class User < ActiveRecord::Base
  include RatingAverage
  has_secure_password
  validates :username, uniqueness: true
  validates :username, length: { in: 3..30 }
  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/}

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings


end
