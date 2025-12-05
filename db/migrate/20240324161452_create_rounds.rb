class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.string :type
      t.date :date
      t.integer :team
      t.string :tee
      t.integer :quota
      t.integer :front
      t.integer :back
      t.integer :total
      t.float :quality
      t.float :skins
      t.float :par3
      t.float :other
      t.string :limited

      t.timestamps
    end
  end
end
