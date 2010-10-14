Feature: Extract Stories
  As a FreeMind user also using Pivotal Tracker
  I want to extract stories from a mind map

  Scenario: Extracting story nodes
    Given a mind map with Story nodes
    When I ask for the stories
    Then I will get a list of stories

