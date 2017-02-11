class FixBeerClubYearColumn < ActiveRecord::Migration
  def change
    rename_column :beer_clubs, :founded, :year
  end
end
