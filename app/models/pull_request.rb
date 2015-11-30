class PullRequest < ActiveRecord::Base
  REPOST_THRESHOLD = ENV.fetch("REPOST_THRESHOLD").to_i

  validates :github_url, presence: true, uniqueness: true
  validates :repo_name, presence: true
  validates :repo_github_url, presence: true
  validates :status, presence: true, inclusion: { in: ["needs review", "in progress", "completed"] }
  validates :title, presence: true
  validates :user_name, presence: true
  validates :user_github_url, presence: true
  validates :avatar_url, presence: true

  has_and_belongs_to_many :tags
  has_many :channels, through: :tags

  time_for_a_boolean :reposted

  def self.active
    where(status: ["needs review", "in progress"])
  end

  def self.for_tags(tag_names)
    if tag_names.present?
      joins(:tags).where(tags: { name: tag_names })
    else
      all
    end
  end

  def self.needs_reposting
    timestamp = REPOST_THRESHOLD.minutes.ago

    updated_before(timestamp).
      where(status: "needs review", reposted_at: nil)
  end

  def self.updated_before(timestamp)
    where("updated_at <= ?", timestamp)
  end

  def tag_names
    tags.map(&:name)
  end

  def number
    github_url.split("/").last
  end
end
