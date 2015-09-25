require "rails_helper"

describe "pull requests API endpoint" do
  it "returns a list of open pull requests" do
    pull_requests = create_pair(:pull_request)

    get "/pull_requests.json"

    prs = json_body
    ids_from_json = prs.map { |pr| pr["id"].to_i }
    ids_from_db = pull_requests.map(&:id)
    expect(ids_from_json).to match_array(ids_from_db)
  end

  it "accepts tag filters" do
    matching_pr = create(:pull_request, tag_names: ["robot"])
    _nonmatching_pr = create(:pull_request, tag_names: ["chicken"])

    get "/pull_requests.json?tags=robot"

    prs = json_body
    expect(prs.count).to eq(1)
    expect(prs.first["id"]).to eq(matching_pr.id)
  end

  def json_body
    JSON.parse(response.body)
  end
end
