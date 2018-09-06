class AddCurrentFrameToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :current_frame, :integer, default: 0
  end
end
