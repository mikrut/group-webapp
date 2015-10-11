class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :discipline, index: true
      t.references :group, index: true
      t.integer :weekday
      t.integer :occurence_type
      t.integer :time_index
      t.integer :lesson_type
    end
    add_foreign_key :lessons, :disciplines
    add_foreign_key :lessons, :groups
  end
end
