class AddDueDateToStash < ActiveRecord::Migration[7.1]
  def change
    add_column :stashes, :due_date, :date
    add_column :stashes, :remarks, :string
  end
end
