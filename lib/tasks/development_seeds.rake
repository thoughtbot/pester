if Rails.env.development?
  require "factory_girl"

  namespace :dev do
    desc "Seed data for development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods
      tag = create(:tag, name: "ember")
      create_list(:pull_request, 5, tags: [tag])
    end
  end
end
