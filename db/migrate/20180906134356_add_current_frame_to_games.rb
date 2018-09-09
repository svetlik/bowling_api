class AddCurrentFrameToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :frame_counter, :integer, default: 0
  end
end
