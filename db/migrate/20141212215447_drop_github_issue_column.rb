class DropGithubIssueColumn < ActiveRecord::Migration
  def change
    remove_column :pull_requests, :github_issue_id
  end
end
