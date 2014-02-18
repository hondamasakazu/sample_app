class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :document_management_id
      t.string :file_path
      t.string :file_name

      t.timestamps
    end
    add_index :documents, :document_management_id
  end
end
