<map version="0.9.0">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1287088763263" ID="ID_54331084" MODIFIED="1287088763263" TEXT="CukeHead">
<cloud COLOR="#ffffff"/>
<node CREATED="1287088763264" MODIFIED="1287088763264" POSITION="left" TEXT="What is it?">
<node CREATED="1287088763264" MODIFIED="1287088763264" TEXT="A toy project to learn how to build a Ruby app, and to learn about Cucumber."/>
<node CREATED="1287088763265" ID="ID_1139739184" MODIFIED="1287088763265" TEXT="A way to visualize the set of Cucumber features for a project."/>
<node CREATED="1287088763265" ID="ID_1342305579" MODIFIED="1287088763265" TEXT="The result of playing around with FreeMind at the same time I wanted to learn about Cucumber."/>
</node>
<node CREATED="1287088763265" ID="ID_1071367071" MODIFIED="1287088822633" POSITION="right" TEXT="Spec">
<node CREATED="1287088763265" ID="ID_1108362858" MODIFIED="1287088763265" TEXT="Cucumber Features:">
<node CREATED="1287088763265" ID="ID_571060612" MODIFIED="1287088902134" TEXT="Feature: CukeHead Map">
<font NAME="SansSerif" SIZE="12"/>
<node CREATED="1287088763265" ID="ID_1334844148" MODIFIED="1287088763265" TEXT="As a person learning or using Cucumber"/>
<node CREATED="1287088763265" MODIFIED="1287088763265" TEXT="I want to view Cucumber features as a FreeMind mind map"/>
<node CREATED="1287088763265" FOLDED="true" ID="ID_600538671" MODIFIED="1287088763265" TEXT="Scenario: Missing Feature section">
<node CREATED="1287088763265" MODIFIED="1287088763265" TEXT="Given a feature file containing the text:"/>
<node CREATED="1287088763265" MODIFIED="1287088763265" TEXT="&quot;&quot;&quot;&#xa;Scenario: foo&#xa;&quot;&quot;&quot;"/>
<node CREATED="1287088763265" MODIFIED="1287088763265" TEXT="Then reading that feature should raise an exception matching &quot;no feature&quot;"/>
</node>
<node CREATED="1287088763265" ID="ID_1488702194" MODIFIED="1287088763265" TEXT="Scenario: Scenario Outline">
<node CREATED="1287088763266" MODIFIED="1287088763266" TEXT="Given a feature file containing the text:"/>
<node CREATED="1287088763266" ID="ID_793046495" MODIFIED="1287088763266" TEXT="&quot;&quot;&quot;&#xa;Feature: A scenario outline&#xa;&#xa;Scenario Outline: eating&#xa;  Given there are &lt;start&gt; cucumbers&#xa;  When I eat &lt;eat&gt; cucumbers&#xa;  Then I should have &lt;left&gt; cucumbers&#xa;&#xa;  Examples:&#xa;    | start | eat | left |&#xa;    |  12   |  5  |  7   |&#xa;    |  20   |  5  |  15  |&#xa;&quot;&quot;&quot;"/>
<node CREATED="1287088763266" MODIFIED="1287088763266" TEXT="When I read the feature into a mind map"/>
<node CREATED="1287088763266" ID="ID_380852527" MODIFIED="1287088763266" TEXT="Then the mind map XML should contain a node with the TEXT attribute &quot;Scenario Outline: eating&quot;"/>
</node>
</node>
<node CREATED="1287088854431" ID="ID_1470665184" MODIFIED="1287089890184" TEXT="Feature: Extract Stories">
<node CREATED="1287088920626" ID="ID_832150598" MODIFIED="1287089855990" TEXT="As a FreeMind user also using Pivotal Tracker"/>
<node CREATED="1287088945003" ID="ID_829384316" MODIFIED="1287088975392" TEXT="I want to extract stories from a mind map"/>
<node CREATED="1287088983469" ID="ID_1787150545" MODIFIED="1287089001249" TEXT="Scenario: Extracting story nodes">
<node CREATED="1287089462890" ID="ID_1927070284" MODIFIED="1287089488130" TEXT="Given a mind map with Story nodes"/>
<node CREATED="1287089489624" ID="ID_1365145931" MODIFIED="1287089573936" TEXT="When I ask for the stories"/>
<node CREATED="1287089575332" ID="ID_1427553163" MODIFIED="1287089601574" TEXT="Then I will get a list of stories"/>
</node>
</node>
</node>
<node CREATED="1287088763266" ID="ID_38329356" MODIFIED="1287088763266" TEXT="Pending features"/>
</node>
</node>
</map>
