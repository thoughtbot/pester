class PullRequest < ActiveRecord::Base
  validates :github_issue_id, presence: true
  validates :github_url, presence: true
  validates :repo_name, presence: true
  validates :status, presence: true
end
