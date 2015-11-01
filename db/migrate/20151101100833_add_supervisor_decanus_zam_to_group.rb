class AddSupervisorDecanusZamToGroup < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.string :supervisor
      t.string :decanus
      t.string :zamdecanus
    end
  end
end
