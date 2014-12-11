class AddColumnsToPullRequests < ActiveRecord::Migration
  def change
    change_table :pull_requests do |t|
      t.string :title, null: false
      t.string :repo_github_url, null: false
      t.string :user_name, null: false
      t.string :user_github_url, null: false
    end
  end
end
