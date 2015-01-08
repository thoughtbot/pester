class AddRepostedAtToPullRequests < ActiveRecord::Migration
  def change
    add_column :pull_requests, :reposted_at, :timestamp
  end
end
