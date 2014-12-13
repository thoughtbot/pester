class AddAvatarUrlToUser < ActiveRecord::Migration
  def change
    change_table :pull_requests do |t|
      t.string :avatar_url, null: false, default: "https://avatars1.githubusercontent.com/u/6183?v=3&s=200"
    end
  end
end
