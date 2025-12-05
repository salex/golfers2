class RemovePermitsFromUser < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :permits, :text
  end
end
