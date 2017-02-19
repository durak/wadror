class MoveOldStylesToStyleTable < ActiveRecord::Migration
  def change
    oldStyles = Beer.select(:style).map(&:style).uniq
    oldStyles.each do |os|
      Style.create(
          :name => os
      )
    end
  end

end
