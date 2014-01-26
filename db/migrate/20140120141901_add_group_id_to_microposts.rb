class AddGroupIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :group_id, :string
  end
end
