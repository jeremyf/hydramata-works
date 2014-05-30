# DRAFT - Interface between Work and Permissions component - DRAFT

## Initial Intreface

For a Work to assert its available predicates, the Permissions subsystem should:

* Provide a `Hydramata::Permissions.roles_for(agent)` service. Responsible for getting all of the roles of an agent.
* Each of the returned objects from `Hydramata::Permissions.roles_for` should:
  * have a unique identifying symbol from which the Work subsystem can craft the appropriate Work Reification Strategy (which properties go on the work value object that is being passed through the system).

The Permissions subsystem is concerned with these three concepts:

* Resource - exposes the following methods `#persisted?`, `#to_key`, `#class#model_name` (a subset of the [ActiveModel::Lint::Test](http://api.rubyonrails.org/classes/ActiveModel/Lint/Tests.html))
* Action - what is the agent trying to do with the resource? This would likely be the Controller#action_name
* Agent - who (or what) is attempting to take action on the resource

For the Permissions subsystem to interact with a Work, the Work object should implement a Resource interface.

## Initial Scenarios

```gherkin
Feature: Role-based access to Predicates
  As the steward of repository content
  I want to ensure that the appropriate content is available based on the requesting Agent.
    And that some content is not available.
  So that I am upholding any institutional policies and protocols regarding content.

  As the Work component is responsible for wrangling the Work from persistence to memory to output buffer,
  it would be the responsiblity of the Work component to negotiate any predicate level access.

  Scenario Outline:

    Given an Agent with role <role>
    And a Work of work type <work_type> with predicates <predicates>
    And the role <role> can only access the following predicates <accessible_predicates>
    When the Agent requests the Work
    Then the Work asserts that the Agent only accesses the following predicates <accessible_predicates>

    Examples:
      | role      | work_type | predicates          | accessible_predicates  |
      | Anonymous | Article   | :identifier, :title | :identifier            |
      | Librarian | Article   | :identifier, :title | :identifier, :title    |
      | Librarian | Article   | :identifier, :title | :identifier, :title    |
```

```gherkin
Feature: Work object interacting with Permissions
  As the steward of repository content
  I want to ensure that the appropriate content is available based on the requesting Agent.
    And that some content is not available.
  So that I am upholding any institutional policies and protocols regarding content.

  Scenario Outline:

    Given an Agent with role <role>
    And a Work of work type <work_type>
    When the Agent requests the Work
    Then the Permissions subsystem asserts that the Agent is <access_state> access to the Work.

    Examples:
      | role      | work_type | access_state |
      | Anonymous | Article   | not allowed  |
      | Librarian | Article   | allowed      |

  Scenario:

    Given an Agent with roles:
      | role      |
      | Professor |
      | Librarian |
    And a Work of work type Article
    And an Article has the following role-based permissions:
      | role      | access_state |
      | Professor | not allowed  |
      | Librarian | allowed      |
    When the Agent requests the Work
    Then the Permissions subsystem asserts that the Agent is allowed access to the Work.

  Scenario:

    Given an Agent with roles:
      | role      |
      | Professor |
      | Librarian |
    And a Work of work type Article
    And an Article has the following role-based permissions:
      | role      | access_state |
      | Professor | not allowed  |
      | Librarian | allowed      |
    When the Agent requests the Work
    Then the Permissions subsystem asserts that the Agent is allowed access to the Work.
```
