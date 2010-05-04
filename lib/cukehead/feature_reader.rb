require 'cukehead/freemind_builder'

class FeatureReader
  
  def initialize
    @builder = FreemindBuilder.new
  end
  
  def extract_features(text)
    
  end
  
  def freemind_xml
    @builder.xml
  end

end
