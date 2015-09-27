class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.date :date_of_birth
      t.boolean :is_admin

      t.timestamps null: false
    end
  end
end
