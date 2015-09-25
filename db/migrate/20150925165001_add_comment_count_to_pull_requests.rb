class AddCommentCountToPullRequests < ActiveRecord::Migration
  def change
    add_column :pull_requests, :comment_count, :integer, null: false, default: 0
  end
end
