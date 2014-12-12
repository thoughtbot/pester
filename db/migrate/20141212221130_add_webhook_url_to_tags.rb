class AddWebhookUrlToTags < ActiveRecord::Migration
  def change
    change_table :tags do |t|
      t.string :webhook_url
    end
  end
end
