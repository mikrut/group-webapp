class CreateDisciplines < ActiveRecord::Migration
  def change
    create_table :disciplines do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end

    add_reference :materials, :discipline, index: true
  end
end
