

class FeatureSection
  attr_accessor :title
  attr_reader :lines
  attr_accessor :tags

  def initialize(title = '')
    @title = title
    @lines = []
    @tags = []
  end

  def add_line(line)
    @lines << line if line.strip.length > 0
  end
end
