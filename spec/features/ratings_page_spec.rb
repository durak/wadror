require 'rails_helper'
include Helpers

describe "Rating" do
  let!(:style) { FactoryGirl.create :style }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "when deleted by the user gets deleted from the db" do
    FactoryGirl.create(:rating, beer:beer1, user:user)
    visit user_path(user)

    expect{
      within('li') do
        click_on("delete")
      end

    }.to change{Rating.count}.from(1).to(0)
  end


end

describe "Ratings" do
  let!(:style) { FactoryGirl.create :style }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:rating1) {FactoryGirl.create(:rating, beer:beer1, user:user)}
  let!(:rating2) {FactoryGirl.create(:rating2, beer:beer1, user:user)}

  it "are shown in correct numbers on the listing page" do
    visit ratings_path

    expect(page).to have_content 'iso 3'
    expect(page).to have_content 'Number of ratings: 2'
  end

  it "are shown in with correct values" do
    visit ratings_path

    expect(page).to have_content 'iso 3, 10'
    expect(page).to have_content 'iso 3, 20'
  end

  it "are shown with correct user name" do
    visit ratings_path

    expect(page).to have_content 'Pekka'
  end

  it "show up on user pages" do
    visit user_path(user)

    expect(page).to have_content 'Has 2 ratings, average 15'
    expect(page).to have_content 'iso 3, 10'
    expect(page).to have_content 'iso 3, 20'

  end

end
