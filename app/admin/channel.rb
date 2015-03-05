ActiveAdmin.register Channel do
  permit_params :name, :webhook_url
end
