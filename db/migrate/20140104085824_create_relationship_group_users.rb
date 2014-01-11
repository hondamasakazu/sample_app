class CreateRelationshipGroupUsers < ActiveRecord::Migration
  def change
    create_table :relationship_group_users do |t|
      t.integer :group_id
      t.integer :user_id

      t.timestamps
    end
    add_index :relationship_group_users, :group_id
    add_index :relationship_group_users, :user_id
    add_index :relationship_group_users, [:group_id, :user_id], unique: true
  end
end
