# Hydramata::AdministrativeSet Strawperson

An Administrative Set is concerned with:

* Somewhat concerned about presentation (i.e. where is this found)
* Default values for ingest
* Might enable bulk editing
* What happens when something is deposited/ingested

* Enable some student to deposit into a specific collection
* Deposit requires review

* What can be added to the set
* Who can add to the set
* Who can modify objects in the set
* What happens when an object that is part of the set changes
* What happens when an object is created in the set

```gherkin
Background:
  Given a User with groups:
    | group                    |
    | Professor of Mathematics |
    | Faculty                  |
  And the following GroupRoles:
    | group                    | role                     |
    | Professor of Mathematics | Math Holdings Manager    |
    | Faculty                  | Faculty Holdings Manager |
    | Students                 | Self Deposit Submitter   |
  And the following AdministrativeSets:
    | set                   |
    | General Holdings      |
    | Self Deposit Holdings |
    | Math Holdings         |
  And the following Permissions:
    | role                     | permissions                                           |
    | General Holdings Manager | can :manage, "General Holdings item of type Article"  |
    | General Holdings Manager | can :manage, "General Holdings item of type Document" |
    | Math Holdings Manager    | can :manage, "General Holdings item of type Article"  |
    | Math Holdings Manager    | can :manage, "General Holdings item of type Dataset"  |
    | Self Deposit Submitter   | can :create, "Self Deposits item of type Document"    |

Scenario:
  Then they 
```
