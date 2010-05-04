require 'cukehead/feature_section'

class FeatureFileSection

  def initialize(builder, title)
    @builder = builder
    @section = FeatureSection.new title    
  end

  def add(line)
    @section.add_line(line)
  end

  def set_tags(tags)
    @section.tags = tags.clone
  end
  
  def finish
    raise "Not implemented"
  end

end


class FeatureSection < FeatureFileSection

  def initialize (builder, text, filename)
    @feature_filename = filename
    super builder, text
  end

  def finish
    @builder.add_feature(@parts, @feature_filename)
  end

end


class BackgroundSection < FeatureFileSection
  def finish
    @builder.add_feature_background(@parts)
  end
end


class ScenarioSection < FeatureFileSection
  def finish
    @builder.add_feature_scenario(@parts)
  end
end

