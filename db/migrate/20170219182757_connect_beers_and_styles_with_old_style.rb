class ConnectBeersAndStylesWithOldStyle < ActiveRecord::Migration
  def change
    Beer.all.each do |beer|
      style = (Style.where name: beer.old_style).first
      beer.update_attribute(:style_id, style.id)
    end
  end
end
