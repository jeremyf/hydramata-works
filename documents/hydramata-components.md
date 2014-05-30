# Hydramata Components

In terms of dependencies, the Work component should happen first.
Then the Permissions and Workflow components can happen independently.

We can begin working on Permissions and Workflow as the Work component is in process.
Permissions will be easier to do in isolation whereas Workflow will require greater coordination with the Work component effort.

Once the Work, Permissions, and Workflow components are complete, most other components could proceed.

## Hydramata::Work

A way to suggest the properties and structure of different work types (ie Article, Dataset, etc) while allowing the persisted work to be the authority of its properties.

Responsible for defining how a work is:

* Represented at three different levels (ie Persistence, Application Object, and User Output).
* Transformed from one level to another (ie Persistence -> Application Object; Application Object -> User Output).

### What pain points is Hydramata::Work addressing?

* Remove duplication of knowledge of a work's data and structure.
  Presently knowledge of a work's data is in the ActiveFedora model, datastreams, show page, and edit page.
* Allow institutions to define their own work types.
* Improve the sharability of components that interact with a well-defined narrow interface for a work.
* Allow institutions to add new work types without requiring deploys.
* Allow institutions to modify existing work types without always requiring data migrations.
* Acknowledge that our understanding of the suggested structure and properties of a work is changing over time, but this shouldn't mandate a migration.

## Hydramata::Permissions

A common interface for application level permissions. That is to say "Can I view this work?" or perhaps more specifically, "When I view this work, what do I see?"

Responsible for defining what an agent interacting with the application can do.

The scope of the permissions system is beyond just works.
Can this person, because they are a member of these groups take this specific action.
And the action could be:

* "Show the Resque worker queue."
* "Masquerade as another user."
* "Edit a given work."

### What pain points is Hydramata::Permissions addressing?

* Normalize the application permissions (i.e. Repository Manager and System Manager are handled differently from a Work's editor)
* Expose a well-defined narrow interface for Groups, so that each institution could create an adaptor that suits them.
* Allow institutions to add new roles to represent a set of abilities (ie a "Librarian" role could edit all AIPs)

## Hydramata::Workflow

A common processing architecture for running tasks that need not be run within a request cycle.

Responsible for providing a asynchronous processing capabilities.
This could be ingesting SIPs, sending emails to depositors, running characterizations, and generating derivatives.

### What pain points is Hydramata::Permissions addressing?

* Acknowledging the fragility of deposit when handled within request queue ([See Google Doc](https://docs.google.com/document/d/1AyEFK0PTIt4STFcsNw2x5zeJthP0rRxKX7K0Yv5O_hM/edit)).
* Acknowledging the transactional challenges of coordinating updates to Fedora and SOLR so as to deliver on the promise of preservation.
* Teasing apart numerous small tasks that can be run and tested in isolation.
* Speeding up the responsiveness and scalability of user deposit.

## Hydramata::AdministrativeSet

A conceptual place where Works are put.

As it relates to the Hydramata::Permissions component, the AdministrativeSet is a Resource.
An AdministrativeSetMembership is also a Resource.

If I want to create a Work, I need to declare which AdministrativeSet I want to put it in.
"Can I create AdministrativeSetMembership (an Article in this AdministrativeSet)?"

### @TODO

Consider how we persist a Work's AdministrativeSet.
Is this uneditable?
Is the attribute shown on the page?
How to enforce that?

The reification strategy.
If a property is present but not editable, discard any value associated with the property when we attempt to.