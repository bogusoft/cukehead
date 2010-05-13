$TESTING=true

$:.push File.join(File.dirname(__FILE__), '..', 'lib')

$testing_tmp = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp'))

$cukehead_bin = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'cukehead'))


class FakeFreemindBuilder
  def add_feature(part, filename)
    @part = part
    @filename = filename    
  end
  
  def add_background(part)
    @part = part
  end
  
  def add_scenario(part)
    @part = part
  end
  
  def lines
    @part.lines
  end  
end