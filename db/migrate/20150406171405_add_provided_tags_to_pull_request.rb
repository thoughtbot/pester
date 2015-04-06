class AddProvidedTagsToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :provided_tags, :string
  end
end
