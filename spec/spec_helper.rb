$TESTING=true

$:.push File.join(File.dirname(__FILE__), '..', 'lib')

$testing_tmp = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp'))

$cukehead_bin = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'cukehead'))

# Fake FreeMind data with one feature with background and two scenarios.
$testing_freemind_data = <<xxx
<map>
  <node TEXT='Cucumber features:'>
    <node TEXT='Feature: Manage websites'>
      <node TEXT='[file: manage_website.feature]'/>
      <node TEXT='In order to manage a website'></node>
      <node TEXT='I want to create and manage a website'></node>
      <node TEXT='Background:'>
        <node TEXT='Given I am the registered user Lime Neeson'></node>
        <node TEXT='And I am on login'></node>
        <node TEXT='When I login with valid credentials'></node>
        <node TEXT='Then I should see &quot;My sites&quot;'></node>
      </node>
      <node TEXT='Scenario: Sites List'>
        <node TEXT='When I go to my sites'></node>
        <node TEXT='Then I should see &quot;My First Site&quot;'></node>
        <node TEXT='And I should see &quot;My Second Site;'></node>
      </node>
      <node TEXT='Scenario: Creating a new site'>
        <node TEXT='When I go to my sites'></node>
        <node TEXT='Then I should see &quot;New site&quot;'></node>
      </node>
    </node>
  </node>
</map>
xxx

# Fake FreeMind data with two features.
$testing_freemind_data_2 = <<xxx
<map>
  <node TEXT='Cucumber features:'>
    <node TEXT='Feature: First feature'>
      <node TEXT='In order to test cukehead'></node>
      <node TEXT='I want some fake data'></node>
      <node TEXT='Scenario: A scenario'>
        <node TEXT='When I ask for a scenario'></node>
        <node TEXT='Then I should get this one'></node>
      </node>
    </node>
    <node TEXT='Feature: Second feature'>
      <node TEXT='In order to further test cukehead'></node>
      <node TEXT='I want to some more fake data'></node>
      <node TEXT='Scenario: Fishing'>
        <node TEXT='When we go fishing'></node>
        <node TEXT='Then you should bring a line'></node>
        <node TEXT='And I should bring a pole'></node>
      </node>
    </node>
  </node>
</map>
xxx

# Fake FreeMind data with no Cucumber features node.
$testing_freemind_data_nocukes = <<xxx
<map>
  <node TEXT='Yes I have no cukes.'>
    <node TEXT='I have no cukes today'/>
  </node>
</map>
xxx


# Fake FreeMind data with upper case 'F' in 'Cucumber Features:'
$testing_freemind_data_case2 = <<xxx
<map>
  <node TEXT='Cucumber Features:'>
    <node TEXT='Feature: Manage websites'>
      <node TEXT='[file: manage_website.feature]'/>
      <node TEXT='In order to manage a website'></node>
      <node TEXT='I want to create and manage a website'></node>
      <node TEXT='Background:'>
        <node TEXT='Given I am the registered user Lime Neeson'></node>
        <node TEXT='And I am on login'></node>
        <node TEXT='When I login with valid credentials'></node>
        <node TEXT='Then I should see &quot;My sites&quot;'></node>
      </node>
      <node TEXT='Scenario: Sites List'>
        <node TEXT='When I go to my sites'></node>
        <node TEXT='Then I should see &quot;My First Site&quot;'></node>
        <node TEXT='And I should see &quot;My Second Site;'></node>
      </node>
      <node TEXT='Scenario: Creating a new site'>
        <node TEXT='When I go to my sites'></node>
        <node TEXT='Then I should see &quot;New site&quot;'></node>
      </node>
    </node>
  </node>
</map>
xxx

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