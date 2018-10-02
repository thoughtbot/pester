if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  namespace :dev do
    desc "Seed data for development environment"
    task prime: "db:setup" do
      include FactoryBot::Syntax::Methods
      tag_names = ["Ember", "Rails", "Objective-C", "Swift", "Design"]
      tag_names.map do |tag_name|
        tag = create(:tag, name: tag_name)
        create(:pull_request, title: "A '#{tag_name}' PR", tags: [tag])
      end

      (2..5).each do |number|
        create(
          :pull_request,
          title: "A PR with multiple tags",
          tags: Tag.all.sample(number),
        )
      end
    end
  end
end
