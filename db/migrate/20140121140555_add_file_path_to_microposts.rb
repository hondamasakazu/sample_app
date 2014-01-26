class AddFilePathToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :file_path, :string
  end
end
