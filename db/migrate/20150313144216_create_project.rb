class CreateProject < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false, unique: true
      t.string :github_url, null: false, unique: true
      t.integer :default_channel_id, null: false
    end

    add_foreign_key(
      :projects,
      :channels,
      column: :default_channel_id,
      on_delete: :cascade
    )
  end
end
