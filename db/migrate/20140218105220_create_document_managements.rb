class CreateDocumentManagements < ActiveRecord::Migration
  def change
    create_table :document_managements do |t|
      t.string :name

      t.timestamps
    end
  end
end
