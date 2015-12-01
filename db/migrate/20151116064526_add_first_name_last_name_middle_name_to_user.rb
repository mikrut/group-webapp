class AddFirstNameLastNameMiddleNameToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :first_name, null: false, default: 'Firstname'
      t.string :last_name, null: false, default: 'Lastname'
      t.string :middle_name, null: false, default: 'Middlename'
    end
  end
end
