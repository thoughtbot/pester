class Tag < ActiveRecord::Base
  validates :channel, presence: true
  validates :channel_id, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  before_validation :normalize_name

  belongs_to :channel

  has_and_belongs_to_many :pull_requests

  def self.with_active_pull_requests
    joins(:pull_requests).
      merge(PullRequest.active).
      uniq
  end

  def pull_requests_count
    pull_requests.active.count
  end

  private

  def normalize_name
    if name.present?
      self.name = name.downcase
    end
  end
end
