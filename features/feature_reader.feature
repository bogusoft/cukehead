Feature: feature reader
  In order to see the overall structure of a set of Cucumber features
  As a silly person
  I want to read feature files and create a FreeMind mind map.

  Background:
    Given a feature file with:
    """
    @atag
    Feature: Do something
    In order to do something
    As a person who is doing nothing
    I want to do something

    Background:
      Given nothing

    Scenario: Choose to do something
      When presented with an opportunity
      And it is not stinky
      Then I should do it



















































"""

  Scenario: Parse a feature file into a set of feature objects.
    When the FeatureReader parses the text from the file
    Then there should be a feature section titled "Do something'

