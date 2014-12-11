class CreateRepos < ActiveRecord::Migration
  def change
    change_table :pull_requests do |t|
      t.belongs_to :repo, null: false, index: true
    end

    revert do
      add_column :pull_requests, :repo_name, :string, null: false
    end

    create_table :repos do |t|
      t.string :full_name
      t.string :github_url
    end

    add_foreign_key :pull_requests, :repos
  end
end
