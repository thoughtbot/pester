class CreateNewPr
  def initialize(payload_parser, *)
    @payload_parser = payload_parser
  end

  def self.matches(payload_parser, *)
    payload_parser.action == "opened" &&
      (
        tags_matched(payload_parser.body) ||
        project_matched(payload_parser.repo_github_url)
      )
  end

  def call
    pull_request = PullRequest.create(pull_request_params)
    post_to_slack(pull_request)
  end

  protected

  attr_reader :payload_parser

  private

  def self.project_matched(repo_github_url)
    ProjectMatcher.match(repo_github_url).any?
  end

  def self.tags_matched(body)
    TagParser.new.parse(body).any?
  end

  def pull_request_params
    payload_parser.params.merge(tags: tags)
  end

  def tags
    @tags ||= tag_names.map { |name| Tag.find_by(name: name) }.compact.uniq
  end

  def tag_names
    @tag_names ||= TagParser.new.parse(payload_parser.body)
  end

  def post_to_slack(pull_request)
    WebhookNotifier.new(pull_request).send_notification
  end
end
