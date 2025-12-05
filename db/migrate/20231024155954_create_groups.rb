class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :tees
      t.text :settings

      t.timestamps
    end
  end
end
