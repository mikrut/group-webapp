class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer
    remove_column :users, :is_admin, :boolean
  end
end
