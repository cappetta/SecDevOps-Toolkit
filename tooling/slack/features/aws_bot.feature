# Created by cappetta at 9/2/18
Feature: As an organization it is important
  for me to have a Slack Bot that I can
  interact with


  Scenario: Basic Bot Connectivitiy
    Given I have a slack "aws bot"
    And that slack bot is started
    Then I ask for help
    And I see the
