class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :semester
      t.integer :cathedra
      t.string :faculty
      t.string :faculty_name
      t.string :cathedra_name
      t.integer :index

      t.timestamps null: false
    end

    add_reference :disciplines, :group, index: true
    add_reference :users, :group, index: true

    add_foreign_key :disciplines, :groups
    add_foreign_key :users, :groups
  end
end
