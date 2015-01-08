$LOAD_PATH.unshift(File.expand_path("../../app", __FILE__))

require "webmock/rspec"
require "active_support/testing/time_helpers"

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.order = :random

  config.include ActiveSupport::Testing::TimeHelpers
end

WebMock.disable_net_connect!(allow_localhost: true)
