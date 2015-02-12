class Tag < ActiveRecord::Base
  SUPPORTED_TAGS = [
    "android",
    "angular",
    "code",
    "design",
    "ember",
    "haskell",
    "ios",
    "javascript",
    "objective-c",
    "rails",
    "react",
    "ruby",
    "swift",
  ]

  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :active_pull_requests, -> { active }, class_name: "PullRequest"

  def self.with_active_pull_requests
    joins(:active_pull_requests).uniq
  end

  def self.with_name(name)
    if SUPPORTED_TAGS.include?(name.downcase)
      find_or_create_by!(name: name.downcase)
    end
  end
end
