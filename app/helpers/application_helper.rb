module ApplicationHelper
  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename)
    render file: file.pathname
  end

  def all_tag_names
    Tag.order(:name).pluck("DISTINCT name")
  end
end
