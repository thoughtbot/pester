class ChangeTagsToChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name, null: false, index: true
      t.string :webhook_url, null: false
    end

    drop_table :pull_requests_tags

    remove_column :tags, :webhook_url
    add_column :tags, :channel_id, :integer, null: false

    create_table :channels_pull_requests do |t|
      t.belongs_to :channel
      t.belongs_to :pull_request
    end

    add_index :channels_pull_requests, [:channel_id, :pull_request_id], unique: true
  end
end
