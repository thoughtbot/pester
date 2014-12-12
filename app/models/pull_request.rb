class PullRequest < ActiveRecord::Base
  validates :github_issue_id, presence: true, numericality: { only_integer: true }, uniqueness: true
  validates :github_url, presence: true
  validates :repo_name, presence: true
  validates :repo_github_url, presence: true
  validates :status, presence: true, inclusion: { in: ["needs review", "in progress", "completed"] }
  validates :title, presence: true
  validates :user_name, presence: true
  validates :user_github_url, presence: true

  has_and_belongs_to_many :tags

  def self.active
    where(status: ["needs review", "in progress"])
  end

  def self.for_tags(tags)
    if tags.present?
      joins(:tags)
        .where(tags: { name: tags })
        .uniq
    else
      all
    end
  end
end
