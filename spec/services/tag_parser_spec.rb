require "spec_helper"
require "services/tag_parser"

describe TagParser do
  it "extracts tags beginning with # from a string" do
    result = TagParser.new.parse("#code")

    expect(result).to eq(["code"])
  end

  it "ignores duplicate tags" do
    result = TagParser.new.parse("#code #web #code")

    expect(result.sort).to eq(["code", "web"])
  end

  it "ignores words which do not start with #" do
    result = TagParser.new.parse("A commit with some stuff #rails #code")

    expect(result.sort).to eq(["code", "rails"])
  end

  it "only selects tags at the boundary of a word" do
    result = TagParser.new.parse("ZOMG stuff#code #rails")

    expect(result).to eq(["rails"])
  end
end
