class CreateNewPr
  def initialize(payload_parser, *)
    @payload_parser = payload_parser
  end

  def self.matches(payload_parser, *)
    payload_parser.action == "opened"
  end

  def call
    tag_names = TagParser.new.parse(payload_parser.body)

    if tag_names.empty?
      tag_names = ["code"]
    end

    tags = tag_names.map(&Tag.method(:with_name))
    PullRequest.create(payload_parser.params.merge(tags: tags))
  end

  protected

  attr_reader :payload_parser
end
