require "rails_helper"

feature "Users views PR detail page" do
  scenario "Sees link to detail of an open Pull Reqeust" do
    pr = create(
      :pull_request,
      title: "Implement Stuff",
      github_url: "https://github.com/thoughtbot/pr-tool/pulls/1",
    )

    visit root_path

    expect(page).to have_link("Show more detail", href: "#{pull_requests_path}/#{pr.id}")

    click_on "Show more detail"
  end
end
