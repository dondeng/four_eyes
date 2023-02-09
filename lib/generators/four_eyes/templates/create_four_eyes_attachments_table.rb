class CreateFourEyesAttachmentsTable < ActiveRecord::Migration[6.1]
  def change
    create_table(:four_eyes_attachments) do |t|
      t.string :name
      t.jsonb :data
      t.timestamps
    end

    add_reference(:four_eyes_attachments, :four_eyes_action, index: true)
  end
end