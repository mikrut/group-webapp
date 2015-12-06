class AddLecturerToLesson < ActiveRecord::Migration
  def change
    change_table :lessons do |l|
      l.string :lecturer
    end
  end
end
