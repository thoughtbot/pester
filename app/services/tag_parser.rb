class TagParser
  def parse(string)
    string.scan(/(\s|^)#([\w]*)/).map(&:last).uniq
  end
end
