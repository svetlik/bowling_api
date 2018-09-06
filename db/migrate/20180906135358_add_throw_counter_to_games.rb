class AddThrowCounterToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :throw_counter, :integer, default: 0
  end
end
