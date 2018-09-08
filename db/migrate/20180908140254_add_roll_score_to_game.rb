class AddRollScoreToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :roll_score, :integer
  end
end
