class DropChannelsPullRequests < ActiveRecord::Migration
  def up
    drop_table :channels_pull_requests
  end

  def down
    create_table :channels_pull_requests do |t|
      t.belongs_to :channel
      t.belongs_to :pull_request
    end

    add_index :channels_pull_requests,
      [:channel_id, :pull_request_id],
      unique: true

    execute <<-EOS
      INSERT INTO channels_pull_requests (channel_id, pull_request_id)
      SELECT tags.channel_id, pull_requests_tags.pull_request_id
      FROM tags, pull_requests_tags
      WHERE tags.id = pull_requests_tags.tag_id
    EOS
  end
end
