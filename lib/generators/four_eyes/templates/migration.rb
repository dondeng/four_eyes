class CreateFourEyesTables < ActiveRecord::Migration
  def self.up
    create_table :four_eyes_actions do |t|
      t.string :action_type
      t.string :resource_class_name
      t.integer :maker_resource_id
      t.integer :checker_resource_id
      t.integer :maker_resource_role_id
      t.integer :checker_resource_role_id
      t.string :object_resource_class_name
      t.integer :object_resource_id
      t.json    :data
      t.string :status

      t.timestamps
    end

    add_index :four_eyes_actions, :maker_resource_id
    add_index :four_eyes_actions, :checker_resource_id
  end

  def self.down
    drop_table :four_eyes_actions
  end
end