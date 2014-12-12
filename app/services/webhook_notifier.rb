class WebhookNotifier
  BOT_NAME = 'Beggar'
  ICON_URL = 'https://pr-tool.herokuapp.com/logo.svg'

  def initialize(pull_request)
    @pull_request = pull_request
  end

  def send_notification
    webhook_urls.each do |url|
      send_webook_post(url)
    end
  end

  def body
    {
      text: title_text,
      username: BOT_NAME,
      icon_url: ICON_URL,
    }.to_json
  end

  protected

  attr_reader :pull_request

  private

  def title_text
    "@PR Needs Review - #{title_link} - (#{tags_string})"
  end

  def send_webook_post(webhook_url)
    uri = URI(webhook_url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.post(uri.path, body)
    end
  end

  def title_link
    "<#{pull_request.github_url}|#{pull_request.title}>"
  end

  def tags_string
    pull_request
      .tag_names
      .map { |s| "##{s}" }
      .join(", ")
  end

  def webhook_urls
    pull_request.webhook_urls
  end
end
