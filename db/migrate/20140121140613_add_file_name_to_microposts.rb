class AddFileNameToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :file_name, :string
  end
end
