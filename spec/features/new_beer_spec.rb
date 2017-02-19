require 'rails_helper'
include Helpers

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"NewBrewery" }
  let!(:user) { FactoryGirl.create :user }
  let!(:style) { FactoryGirl.create :style }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "can be created from web form by signed in user" do
    visit new_beer_path
    fill_in('beer[name]', with:'Beer III')
    select('NewBrewery', from:'beer[brewery_id]')
    select('Lager', from:'beer[style_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

  end

    it "with empty name can't be created" do
      visit new_beer_path
      select('NewBrewery', from:'beer[brewery_id]')
      select('Lager', from:'beer[style_id]')

      expect{
        click_button "Create Beer"
      }.to_not change{Beer.count}
      expect(page).to have_content 'Name can\'t be blank'
    end
end