class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.references :group, null: false, foreign_key: true
      t.date :date
      t.string :status
      t.string :method
      t.text :scoring
      t.text :par3
      t.text :skins

      t.timestamps
    end
  end
end
