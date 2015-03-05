require "rails_helper"

describe Tag do
  it { should validate_presence_of(:name) }
  it { should belong_to(:channel) }
end
