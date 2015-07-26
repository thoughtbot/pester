class Channel < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :projects, as: :default_channel, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_and_belongs_to_many :active_pull_requests, -> { active }, class_name: "PullRequest"

  def self.with_active_pull_requests
    joins(:active_pull_requests).uniq
  end

  def self.with_tag_name(tag_names)
    joins(:tags).find_by(tags: { name: tag_names })
  end
end
