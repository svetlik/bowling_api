class AddFramesToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :frames, :string, array: true, default: []
  end
end
