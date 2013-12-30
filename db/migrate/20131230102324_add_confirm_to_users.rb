class AddConfirmToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirm, :boolean, default: false
  end
end
