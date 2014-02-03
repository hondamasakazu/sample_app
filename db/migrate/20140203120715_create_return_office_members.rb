class CreateReturnOfficeMembers < ActiveRecord::Migration
  def change
    create_table :return_office_members do |t|
      t.integer :return_office_date_id
      t.integer :user_id
      t.string :join_flg
      t.string :remarks

      t.timestamps
    end
    add_index :return_office_members, :return_office_date_id
    add_index :return_office_members, :user_id
    add_index :return_office_members, [:return_office_date_id, :user_id], unique: true, name: 're_of_members'
  end
end
