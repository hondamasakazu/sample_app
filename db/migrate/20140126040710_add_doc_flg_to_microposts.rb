class AddDocFlgToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :doc_flg, :boolean
  end
end
