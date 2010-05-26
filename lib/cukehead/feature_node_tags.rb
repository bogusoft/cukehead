module Cukehead

  # Responsible for holding a string of tags extracted from a mind map
  # node and providing it in the format used in a Cucumber feature file.
  #
  class FeatureNodeTags

    def initialize
      @tagstr = ''
    end

    
    # Extracts the substring containing the tags from a string in the format
    # <i>Tags: tag1 tag2</i>
    # ===Parameters
    # <tt>text</tt> - String containing tags from mind map node text.
    #
    def from_text(text)
      a = text.split(':')
      if a.length == 2
        @tagstr = a[1].strip
      end
    end

    
    # Returns the string of tags extracted by from_text in the format
    # needed for output to a feature file.
    # ===Parameters
    # <tt>pad</tt> - String of whitespace to use to indent the tags.
    #
    def to_text(pad)
      if @tagstr.length == 0
        ''
      else
        pad + @tagstr + "\n"
      end
    end

  end

end