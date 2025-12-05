class GamesChangeScoringToFormed < ActiveRecord::Migration[7.1]
  def change
    rename_column :games, :scoring, :formed
  end
end
