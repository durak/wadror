require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"
    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username:"Pekka", password:"Se1", password_confirmation:"Se1"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with only letters in a password" do
    user = User.create username:"Pekka", password:"OnlyAlphabeticalPassword", password_confirmation:"OnlyAlphabeticalPassword"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favourite beer" do
    let(:user){FactoryGirl.create(:user)}


    it "has method for determining one" do
      expect(user).to respond_to(:favourite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favourite_beer).to eq(nil)
    end

    it "is the only rated if only one has been rated" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favourite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15)
      best = create_beer_with_rating(user, 25)

      expect(user.favourite_beer).to eq(best)
    end

  end

  describe "favourite style" do
    !let(:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favourite_style)
    end

    it "without rated beers does not have one" do
      expect(user.favourite_style).to eq(nil)
    end

    it "with one rated beer is style of this rated beer" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favourite_style).to eq(beer.style)
    end

    it "with multiple rated beers is the one with highest average of ratings" do
      beer1 = FactoryGirl.create(:beer, style: 'Lager')
      beer2 = FactoryGirl.create(:beer, style: 'Weizen')
      rating1 = FactoryGirl.create(:rating, beer: beer1, user:user)
      rating2 = FactoryGirl.create(:rating, beer: beer1, user:user)
      rating3 = FactoryGirl.create(:rating2, beer: beer2, user:user)

      expect(user.favourite_style).to eq('Weizen')

    end

  end

  describe "favourite brewery" do
    !let(:user){FactoryGirl.create(:user)}
    !let(:brewery1){FactoryGirl.create(:brewery)}
    !let(:brewery2){FactoryGirl.create(:brewery, name:'best')}

    it "has method for determining one" do
      expect(user).to respond_to(:favourite_brewery)
    end

    it "without rated beers does not have one" do
      expect(user.favourite_brewery).to eq(nil)
    end


    it "is one with highest average rating" do
      beer1 = FactoryGirl.create(:beer, style: 'Lager', brewery: brewery1)
      beer2 = FactoryGirl.create(:beer, style: 'Weizen', brewery: brewery2)
      rating1 = FactoryGirl.create(:rating, beer: beer1, user:user)
      rating2 = FactoryGirl.create(:rating, beer: beer1, user:user)
      rating3 = FactoryGirl.create(:rating2, beer: beer2, user:user)

      expect(user.favourite_brewery).to eq(brewery2)
    end


  end




  describe "with a proper password" do
    let(:user){FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and two ratings, has the correct average rating" do

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end

  end

  def create_beer_with_rating(user, score)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(user, *scores)
    scores.each do |score|
      create_beer_with_rating(user, score)
    end
  end

end
