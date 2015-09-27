class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
