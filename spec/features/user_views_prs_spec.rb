require "rails_helper"

feature "User views PRs" do
  scenario "Sees all open Pull Requests" do
    create(:pull_request, title: "Implement Stuff")
    create(:pull_request, title: "Design Stuff")

    visit root_path

    expect(page).to have_content("Implement Stuff")
    expect(page).to have_content("Design Stuff")
  end

  scenario "Sees link to PR on Github" do
    create(:pull_request, title: "Implement Stuff", github_url: "https://github.com/thoughtbot/pr-tool/pulls/1")

    visit root_path

    expect(page).to have_link("Implement Stuff", href: "https://github.com/thoughtbot/pr-tool/pulls/1")
  end

  scenario "Sees link to repo on Github" do
    create(:pull_request, repo_name: "thoughtbot/pr-tool", repo_github_url: "https://github.com/thoughtbot/pr-tool")

    visit root_path

    expect(page).to have_link("thoughtbot/pr-tool", href: "https://github.com/thoughtbot/pr-tool")
  end

  scenario "Sees metadata" do
    create(
      :pull_request,
       github_issue_id: 123,
       created_at: 1.hour.ago,
       user_name: "JoelQ",
       user_github_url: "https://github.com/joelq",
    )

    visit root_path

    expect(page).to have_content("#123 opened about 1 hour ago by JoelQ")
    expect(page).to have_link("JoelQ", href: "https://github.com/joelq")
  end
end
