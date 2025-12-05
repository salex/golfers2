class CreateStashes < ActiveRecord::Migration[7.1]
  def change
    create_table :stashes do |t|
      t.string :stashable_type
      t.bigint :stashable_id
      t.string :type
      t.bigint :ref_id
      t.string :title
      t.string :content
      t.string :slim
      t.text :hash_data
      t.text :text_data
      t.date :date
      t.string :status

      t.timestamps
    end
  end
end
