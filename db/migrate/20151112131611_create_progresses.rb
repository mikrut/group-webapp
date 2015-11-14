class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.float :percentage, null: false, default: 0
      t.references :user, index: true
      t.references :discipline, index: true

      t.timestamps null: false
    end
  end
end
