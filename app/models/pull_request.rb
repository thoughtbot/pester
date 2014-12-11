class PullRequest < ActiveRecord::Base
  validates :github_issue_id, presence: true, numericality: { only_integer: true }
  validates :github_url, presence: true
  validates :repo_name, presence: true
  validates :repo_github_url, presence: true
  validates :status, presence: true
  validates :title, presence: true
  validates :user_name, presence: true
  validates :user_github_url, presence: true
end
