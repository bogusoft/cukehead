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


  class FeatureNodeChild

    def initialize(node)
      @description = []
      @tags = FeatureNodeTags.new
      @title = node.attributes["TEXT"]
      from_mm_node node
    end

    def from_mm_node(node)
      if node.has_elements?
        node.elements.each do |e|
          text = e.attributes["TEXT"]
          unless text.nil?
            if text =~ /^Tags:*/i
              @tags.from_text text
            else
              @description << text
            end
          end
        end
      end
    end

    def to_text(pad)

      #*!* DEBUG
      #$stderr.puts("------------------------------------------------------------")
      #@description.each {|d| $stderr.puts('[' + d.dump + "]\n")}

      s = "\n"
      @description.each {|d| s += pad + "  " + d + "\n"}
      pad + @tags.to_text(pad) + @title + s
    end
  end


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

    def title_as_filename
      result = ''
      t = @title.strip.gsub(/^feature:/i, ' ').strip
      t.downcase.gsub(/\ /, '_').scan(/[_0-9a-z]/) {|c| result << c }
      result + '.feature'
    end

    def filename
      if @feature_filename.empty?
        title_as_filename
      else
        @feature_filename
      end
    end

    
    def filename_from(text)
      # filename_from '[file: filename.feature]'
      # filename_from '[file: "filename.feature"]'
      a = text.index ':'
      if a.nil? then return "" end
      b = text.index ']'
      if b.nil? then return "" end
      a += 1
      if a > 5 and b > a
        text.slice(a, b-a).delete('"').strip
      else
        ""
      end
    end
    

    def from_mm_node(node)
      if node.has_elements?
        node.elements.each do |e|
        text = e.attributes["TEXT"]
          if !text.nil?
            case text
              when /^Background:*/i
                @backgrounds << FeatureNodeChild.new(e)
              when /^Scenario:*/i
                @scenarios << FeatureNodeChild.new(e)
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

    def to_text
      text = @tags.to_text('') + @title + "\n"
      pad = "  "
      @description.each {|line| text += pad + line + "\n"}
      text += "\n"
      @backgrounds.each {|background| text += background.to_text(pad) + "\n"}
      @scenarios.each {|scenario| text += scenario.to_text(pad) + "\n"}
      text
    end

  end

end