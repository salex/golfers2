class Group < ActiveRecord::Migration[7.1]
  def change
    rename_column :groups, :cources, :courses
  end
end
