@feature_tag
Feature: A second test feature
In order test more stuff
As a stuff tester
I want to throw more stuff into the mix

# This one is from the Cucumber examples
# http://github.com/aslakhellesoy/cucumber/blob/master/examples/i18n/en/features/addition.feature
  @scenario_tag
  Scenario Outline: Add two numbers
    Given I have entered <input_1> into the calculator
    And I have entered <input_2> into the calculator
    When I press <button>
    Then the result should be <output> on the screen

  Examples:
    | input_1 | input_2 | button | output |
    | 20      | 30      | add    | 50     |
    | 2       | 5       | add    | 7      |
    | 0       | 40      | add    | 40     |

  


