class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.string :secret_key
      t.string :username

      t.timestamps null: false
    end
  end
end
