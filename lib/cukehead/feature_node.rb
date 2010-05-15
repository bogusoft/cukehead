require 'rexml/document'

module Cukehead

  class FeatureNodeTags

    def initialize
      @tagstr = ''
    end

    def from_text(text)
      a = text.split(':')
      if a.length == 2
        @tagstr = a[1].strip
      end
    end

    def to_text(pad)
      if @tagstr.length == 0
        ''
      else
        pad + @tagstr + "\n"
      end
    end

  end


#  class FeatureNodeChild
#    def initialize(title)
#      @title = title
#      @description = []
#      @tags = FeatureTags.new
#    end
#
#    def from_mm_node(node)
#      if node.has_elements?
#        node.elements.each do |e|
#          text = e.attributes["TEXT"]
#          unless text.nil?
#            if text =~ /^Tags:*/i
#              @tags.from_text text
#            else
#              @description << text
#            end
#          end
#        end
#      end
#    end
#
#    def to_text(pad)
#
#      #*!* DEBUG
#      #$stderr.puts("------------------------------------------------------------")
#      #@description.each {|d| $stderr.puts('[' + d.dump + "]\n")}
#
#      s = "\n"
#      @description.each {|d| s += pad + "  " + d + "\n"}
#      pad + @tags.to_text(pad) + @title + s
#    end
#  end



  class FeatureNode

    def initialize(node)
      @feature_filename = ""
      @description = []
      @backgrounds = []
      @scenarios = []
      @tags = FeatureNodeTags.new
      @title = node.attributes["TEXT"]
      from_mm_node node
    end
    
    def from_mm_node(node)
      if node.has_elements?
        node.elements.each do |e|
        text = e.attributes["TEXT"]
         if !text.nil?
          case text
            when /^Background:*/i
              background = new_background text
              background.from_mm_node(e)
            when /^Scenario:*/i
              scenario = new_scenario text
              scenario.from_mm_node(e)
            when /^\[file:.*/i
              @feature_filename = filename_from text
            when /^Tags:*/i
              @tags.from_text text
          else
            @description << text
          end
         end
        end
      end
    end

  end

end