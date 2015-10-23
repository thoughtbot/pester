module ApplicationHelper
  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename)
    render file: file.pathname
  end

  def all_tags_channels
    Tag.joins(:channel).order(:name).pluck("tags.name", "channels.name")
  end
end
