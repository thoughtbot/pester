class PullRequest < ActiveRecord::Base
  REPOST_THRESHOLD = 30

  validates :github_url, presence: true, uniqueness: true
  validates :repo_name, presence: true
  validates :repo_github_url, presence: true
  validates :status, presence: true, inclusion: { in: ["needs review", "in progress", "completed"] }
  validates :title, presence: true
  validates :user_name, presence: true
  validates :user_github_url, presence: true
  validates :avatar_url, presence: true

  has_and_belongs_to_many :tags

  time_for_a_boolean :reposted

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

  def self.needs_reposting
    timestamp = REPOST_THRESHOLD.minutes.ago

    updated_before(timestamp).
      where(status: "needs review", reposted_at: nil)
  end

  def self.updated_before(timestamp)
    where("updated_at <= ?", timestamp)
  end

  def number
    github_url.split("/").last
  end

  def tag_names
    tags.map(&:name)
  end

  def webhook_urls
    tags.map(&:webhook_url).compact.uniq
  end

  def slug
    @slug ||= calculate_slug
  end

  protected

  def calculate_slug
    github_parts = github_url.split("//").last.split("/")
    "#{github_parts[1]}-#{github_parts[2]}-#{github_parts[4]}"
  end
end
