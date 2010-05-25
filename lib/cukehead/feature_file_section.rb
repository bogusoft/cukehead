require 'cukehead/feature_part'

module Cukehead

  # Base class for a container that holds a part of a Cucumber
  # feature file that will be passed to a FreemindBuilder object
  # once the part has been read.
  #
  class FeatureFileSection

    # Parameters:
    # builder:: Instance of FreemindBuilder that will receive this
    # section of the file.
    # title:: String containing the title of the section.
    #
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


  # Serves as a container for the feature description part of a Cucumber 
  # feature file while parsing the file.
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
      @builder.add_background(@part)
    end

  end


  class ScenarioSection < FeatureFileSection

    def finish
      @builder.add_scenario(@part)
    end

  end

end
