class AddCourseToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :course, :string
  end
end
