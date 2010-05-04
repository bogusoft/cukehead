require 'cukehead/freemind_builder'

class FeatureReader
  
  def initialize
    @builder = FreemindBuilder.new
  end
  
  def extract_features(filename, text)
    @section = nil
    in_literal_text = false
    literal_text = ''
    tags = []
    text.each_line do |line|
      s = line.strip
      #$stderr.puts "DEBUG: LINE='#{s}'"
      if s == '"""'
        if in_literal_text
          @section.add(literal_text + "\n\"\"\"") unless @section == nil
          in_literal_text = false
        else
          literal_text = "\"\"\"\n"
          in_literal_text = true
        end
      else  
        if in_literal_text
          literal_text << line
        else
          case s
            when /^\@.*/i
              tags = s.split(' ')
            when /^Feature:*/i
              @section.finish unless @section == nil
              @section = FeatureSection.new(@builder, line, filename)
              @section.set_tags tags
              tags.clear
            when /^Background:*/i
              @section.finish unless @section == nil
              @section = BackgroundSection.new(@builder, line)
              @section.set_tags tags
              tags.clear
            when /^Scenario:*/i
              @section.finish unless @section == nil
              @section = ScenarioSection.new(@builder, line)
              @section.set_tags tags
              tags.clear
            else
              @section.add(line) unless @section == nil
          end
        end
      end
    end
    @section.finish unless @section == nil
  end
  
  def freemind_xml
    @builder.xml
  end

end
