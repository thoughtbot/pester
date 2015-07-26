class RemoveWebhookUrlFromChannels < ActiveRecord::Migration
  def change
    remove_column :channels, :webhook_url, :string, null: false
  end
end
