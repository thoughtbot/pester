class Project < ActiveRecord::Base
  validates :default_channel, presence: true
  validates :github_url, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  belongs_to :default_channel, class_name: "Channel"
end
