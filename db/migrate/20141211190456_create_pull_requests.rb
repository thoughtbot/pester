class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.timestamps null: false

      t.integer :github_issue_id, null: false
      t.string :github_url, null: false
      t.string :repo_name, null: false
      t.string :status, null: false, default: 'needs review', index: true
    end
  end
end
