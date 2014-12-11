module ApplicationHelper
  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename)
    render file: file.pathname
  end
end
