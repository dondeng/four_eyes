class UpdateFourEyesTablesOne < ActiveRecord::Migration
  def change
    remove_index :four_eyes_actions, [:maker_resource_id]
    remove_index :four_eyes_actions, [:checker_resource_id]

    #Rename columns to cater for polymorhphisim
    rename_column :four_eyes_actions, :resource_class_name, :maker_type
    rename_column :four_eyes_actions, :maker_resource_id, :maker_id
    rename_column :four_eyes_actions, :checker_resource_id, :checker_id
    rename_column :four_eyes_actions, :object_resource_class_name, :object_resource_type
    rename_column :four_eyes_actions, :maker_resource_role_id, :maker_role_id
    rename_column :four_eyes_actions, :checker_resource_role_id, :checker_role_id

    add_column :four_eyes_actions, :checker_type, :string, after: :checker_id
    add_column :four_eyes_actions, :assignable_type, :string
    add_column :four_eyes_actions, :assignable_id, :integer

    add_index :four_eyes_actions, :maker_id
    add_index :four_eyes_actions, [:maker_type, :maker_id]
    add_index :four_eyes_actions, :checker_id
    add_index :four_eyes_actions, [:checker_type, :checker_id]
    add_index :four_eyes_actions, :assignable_id
    add_index :four_eyes_actions, [:assignable_type, :assignable_id]
  end
end