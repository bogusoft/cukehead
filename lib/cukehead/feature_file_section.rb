require 'cukehead/feature_part'

class FeatureFileSection

  def initialize(builder, title)
    @builder = builder
    @part = FeaturePart.new title    
  end

  def add(line)
    @part.add_line(line)
  end

  def set_tags(tags)
    @part.tags = tags.clone
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
    @builder.add_feature(@part, @feature_filename)
  end

end


class BackgroundSection < FeatureFileSection
  
  def finish
    @builder.add_feature_background(@part)
  end
  
end


class ScenarioSection < FeatureFileSection
  
  def finish
    @builder.add_feature_scenario(@part)
  end
  
end

