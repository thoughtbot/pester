class AddStatsToPr < ActiveRecord::Migration
  def change
    add_column :pull_requests, :additions, :integer, null: false, default: 0
    add_column :pull_requests, :deletions, :integer, null: false, default: 0
  end
end
