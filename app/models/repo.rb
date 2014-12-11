class Repo < ActiveRecord::Base
  validates :full_name, presence: true
  validates :github_url, presence: true

  has_many :pull_requests
end
