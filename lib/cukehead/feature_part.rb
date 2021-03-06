module Cukehead

  # Container for text from part of a feature file (feature description, 
  # background, scenario).
  #
  class FeaturePart
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

end

