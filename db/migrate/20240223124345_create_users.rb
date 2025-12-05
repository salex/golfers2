class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.references :group, null: false, foreign_key: true
      t.string :fullname
      t.string :username
      t.string :email
      t.string :role
      t.text :permits

      t.timestamps
    end
  end
end
