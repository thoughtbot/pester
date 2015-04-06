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
    pr_options = { channels: channels, provided_tags: provided_tags }
    merged_params = payload_parser.params.merge(pr_options)
    pull_request = PullRequest.create(merged_params)
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

  def channels
    [tag_channels, project_channels].flatten.compact
  end

  def project_channels
    @projects ||= begin
      projects = ProjectMatcher.match(payload_parser.repo_github_url)
      unique_channels(list: projects, method: :default_channel)
    end
  end

  def tag_channels
    @tags ||= begin
      tag_names = TagParser.new.parse(payload_parser.body)
      unique_channels(list: tag_names, method: Channel.method(:with_tag_name))
    end
  end

  def provided_tags
    TagParser.new.parse(payload_parser.body)
  end

  def post_to_slack(pull_request)
    WebhookNotifier.new(pull_request).send_notification
  end

  def unique_channels(list:, method:)
    list.map(&method).compact.uniq
  end
end
