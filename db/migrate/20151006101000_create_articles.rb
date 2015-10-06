class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :contents
      t.integer :author_id

      t.timestamps null: false
    end

    add_reference :articles, :discipline, index: true
    add_foreign_key :articles, :disciplines
    add_foreign_key :articles, :users, column: :author_id
  end
end
