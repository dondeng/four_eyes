class CreateFourEyesTables < ActiveRecord::Migration
  def self.up
    create_table :four_eyes_actions do |t|
      t.string :action_type
      t.string :maker_type
      t.integer :maker_id
      t.string :checker_type
      t.integer :checker_id
      t.integer :maker_role_id
      t.integer :checker_role_id
      t.string :object_resource_type
      t.integer :object_resource_id
      t.string :assignable_type
      t.string :assignable_id
      t.json    :data
      t.string :status

      t.timestamps
    end

    add_index :four_eyes_actions, :maker_id
    add_index :four_eyes_actions, [:maker_type, :maker_id]
    add_index :four_eyes_actions, :checker_id
    add_index :four_eyes_actions, [:checker_type, :checker_id]
    add_index :four_eyes_actions, :assignable_id
    add_index :four_eyes_actions, [:assignable_type, :assignable_id]
  end

  def self.down
    drop_table :four_eyes_actions
  end
end