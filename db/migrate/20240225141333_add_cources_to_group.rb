class AddCourcesToGroup < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :cources, :text
  end
end
