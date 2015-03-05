class CreateNewPr
  def initialize(payload_parser, *)
    @payload_parser = payload_parser
  end

  def self.matches(payload_parser, *)
    payload_parser.action == "opened" &&
      TagParser.new.parse(payload_parser.body).any?
  end

  def call
    merged_params = payload_parser.params.merge(channels: channels)
    pull_request = PullRequest.create(merged_params)
    post_to_slack(pull_request)
  end

  protected

  attr_reader :payload_parser

  private

  def channels
    @tags ||= begin
      tag_names = TagParser.new.parse(payload_parser.body)
      tag_names.map(&Channel.method(:with_tag_name)).compact.uniq
    end
  end

  def post_to_slack(pull_request)
    WebhookNotifier.new(pull_request).send_notification
  end
end
