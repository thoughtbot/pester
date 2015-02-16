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

  scenario "User sees History" do
    pr = create(
      :pull_request,
      title: "Show more detail",
      status: "needs review",
      created_at: 2.hours.ago,
      updated_at: 1.hour.ago,
      reposted_at: 90.minutes.ago,
    )

    visit pull_request_path(pr)

    expect(page).to have_css("[data-role='history'] > h3", text: "History")
    expect(page).to have_css("[data-role='date-added']", text: 2.hours.ago)
    expect(page).to have_css("[data-role='date-updated']", text: 1.hours.ago)
    expect(page).to have_css("[data-role='date-reposted']", text: 90.minutes.ago)
    expect(page).to have_css("[data-role='status']", text: "needs review")
  end
end
