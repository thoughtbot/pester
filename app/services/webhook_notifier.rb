class WebhookNotifier
  BOT_NAME = "Pester"
  ICON_URL = "http://tbot-pester.herokuapp.com/pester-slack-icon.png"

  def initialize(pull_request)
    @pull_request = pull_request
  end

  def send_notification
    channels.each do |channel|
      send_webook_post(channel)
    end
  end

  def body(channel)
    {
      text: title_text,
      username: BOT_NAME,
      icon_url: ICON_URL,
      channel: channel.name,
    }.to_json
  end

  protected

  attr_reader :pull_request

  private

  def title_text
    ":pr: @PR #{repo_name} (#{tags_string}) (#{statistics_strings}) - #{title_link}"
  end

  def statistics_strings
    "+#{pull_request.additions}, -#{pull_request.deletions}"
  end

  def send_webook_post(channel)
    uri = URI(channel.webhook_url)
    Net::HTTP.start(
      uri.host,
      uri.port,
      use_ssl: uri.scheme == "https"
    ) do |http|
      http.post(uri.path, body(channel))
    end
  end

  def title_link
    "<#{pull_request.github_url}|#{pull_request.title}>"
  end

  def repo_name
    pull_request.repo_name
  end

  def tags_string
    tag_names.join(", ")
  end

  def tag_names
    pull_request.tag_names.map { |name| "##{name}" }
  end

  def channels
    pull_request.channels
  end
end
