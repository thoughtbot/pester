class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false, index: true, unique: true
    end

    create_table :pull_requests_tags do |t|
      t.belongs_to :pull_request
      t.belongs_to :tag
    end

    add_foreign_key :pull_requests_tags, :pull_requests
    add_foreign_key :pull_requests_tags, :tags
    add_index :pull_requests_tags, [:pull_request_id, :tag_id], unique: true
  end
end
