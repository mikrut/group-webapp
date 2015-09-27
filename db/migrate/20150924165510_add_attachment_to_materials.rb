class AddAttachmentToMaterials < ActiveRecord::Migration
  def up
    add_attachment :materials, :document
  end

  def down
    remove_attachment :materials, :document
  end
end
