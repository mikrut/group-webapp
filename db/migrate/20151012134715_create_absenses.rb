class CreateAbsenses < ActiveRecord::Migration
  def change
    create_table :absenses do |t|
      t.references :user, index: true
      t.references :lesson, index: true
      t.integer :week
      t.text :reason_commentary
    end
  end
end
