ActiveAdmin.register Project do
  permit_params :name, :default_channel_id, :github_url
end
