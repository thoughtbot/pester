class Tag < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  belongs_to :channel
end
