class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.references :group, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :nickname
      t.boolean :use_nickname
      t.string :name
      t.string :tee
      t.integer :quota
      t.float :rquota
      t.string :phone
      t.boolean :is_frozen
      t.date :last_played
      t.integer :pin
      t.string :limited

      t.timestamps
    end
  end
end
