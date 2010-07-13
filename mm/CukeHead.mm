<map version="0.7.1">
<node TEXT="CukeHead">
<cloud COLOR="#ffffff"/>
<node TEXT="What is it?" POSITION="left">
<node TEXT="A toy project to learn how to build a Ruby app, and to learn about Cucumber."/>
<node TEXT="A way to visualize the set of Cucumber features for a project."/>
<node TEXT="The result of playing around with FreeMind at the same time I wanted to learn about Cucumber."/>
</node>
<node TEXT="Spec" POSITION="right">
<node TEXT="Cucumber Features:">
<node TEXT="Feature: CukeHead Map">
<font NAME="SansSerif" SIZE="12"/>
<node TEXT="As a person learning or using Cucumber"/>
<node TEXT="I want to view Cucumber features as a FreeMind mind map"/>
<node TEXT="Scenario: Missing Feature section" FOLDED="true">
<node TEXT="Given a feature file containing the text:"/>
<node TEXT="&quot;&quot;&quot;&#xa;Scenario: foo&#xa;&quot;&quot;&quot;"/>
<node TEXT="Then reading that feature should raise an exception matching &quot;no feature&quot;"/>
</node>
<node TEXT="Scenario: Scenario Outline">
<node TEXT="Given a feature file containing the text:"/>
<node TEXT="&quot;&quot;&quot;&#xa;Feature: A scenario outline&#xa;&#xa;Scenario Outline: eating&#xa;  Given there are &lt;start&gt; cucumbers&#xa;  When I eat &lt;eat&gt; cucumbers&#xa;  Then I should have &lt;left&gt; cucumbers&#xa;&#xa;  Examples:&#xa;    | start | eat | left |&#xa;    |  12   |  5  |  7   |&#xa;    |  20   |  5  |  15  |&#xa;&quot;&quot;&quot;"/>
<node TEXT="When I read the feature into a mind map"/>
<node TEXT="Then the mind map XML should contain a node with the TEXT attribute &quot;Scenario Outline: eating&quot;"/>
</node>
</node>
</node>
<node TEXT="Pending features"/>
</node>
</node>
</map>
