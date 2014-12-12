if Rails.env.development?
  require "factory_girl"

  namespace :dev do
    desc "Seed data for development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods
      ember = create(:tag, name: "ember")
      rails = create(:tag, name: "rails")
      create(:pull_request, title: "An Ember PR", tags: [ember])
      create(:pull_request, title: "A Rails PR", tags: [rails])
      create(:pull_request, title: "A PR that should probably have been split up", tags: [rails, ember])
    end
  end
end
