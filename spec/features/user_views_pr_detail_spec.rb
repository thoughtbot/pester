require "rails_helper"

feature "Users views PR detail page" do
  scenario "Clicking a detail link opens a Pull Request detail page" do
    pr = create(
      :pull_request,
      title: "Implement Stuff",
      github_url: "https://github.com/thoughtbot/pr-tool/pulls/1",
    )

    visit root_path

    expect(page).to have_link("Show more detail", href: "#{pull_requests_path}/#{pr.id}")

    click_link("Show more detail")

    expect(page).to have_css("[data-role='pull-request-detail']", text: "Implement Stuff")
  end
end
