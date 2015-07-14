class Tag < ActiveRecord::Base
  validates :channel, presence: true
  validates :channel_id, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  belongs_to :channel
end
