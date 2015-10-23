class Channel < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: { scope: :webhook_url }
  validates :webhook_url, presence: true

  has_many :projects, as: :default_channel, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :active_pull_requests,
    -> { active },
    through: :tags,
    source: :pull_requests

  def self.with_tag_name(tag_names)
    joins(:tags).find_by(tags: { name: tag_names })
  end
end
