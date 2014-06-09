# Proposed Hydramata Timeline

## Work

### Where does this exist in Curate?

Presently the definition of a Work is spread across six major concerns:

* Model - exposes attributes, validations, defines model level indexing strategy
* Datastream - exposes attributes and indexing strategy
* Actor - handles input interactions, DOI minting, file uploading
* Show page - renders attributes
* Edit page - renders attributes (and values)
* Index/search result - renders attributes and values

The sequence of rendered attributes is not kept in sync between the different view contexts.

### Replacement Strategy


1. Define the narrow public interface for a Work's expected methods and their behavior.
   This involves providing object linters to verify the API.
1. Establish application plugin structure.
1. Data-driven presentation structure for Work Types
   This addresses the rendering aspect of the Show/New/Edit page.
1. Splice in a shim for rendering existing Curate work types via data-driven methods
1. Data-driven predicate definition for Work Types
   This addresses indexing strategy, validation, and configurablity of work types.
1. Splice in the Work Wrangler to reify Fedora objects
1. Splice in WorkActorShim to preserve existing Curate Actor behaviors

## Workflow

### Where does this exist in Curate?

Presently this exists in the Actor and spread across numerous callbacks for Hydra components

* Creating child GenericFiles under a Work
* Derivatives
* Remote Identifiers (DOIs)
* Generate checksums
* Characterization
* Assigning a representative image
* Running anti-virus
* Establish provenance of attachments

### Replacement Strategy

1. Create or leverage existing Workflow project (i.e. push Heracles over the hump) to implement an asynchronous messaging system.
1. Create single-focus tasks (i.e. hydramata/work/tasks/generate_derivatives) that behave well within the Workflow subsystems
1. Replace existing Curate actors with data-driven Workflows.
   This will obviate the need for the WorkActorShim as the Workflows expect to interact with objects that implement the Work interface.

## Permissions

### Where does this exist in Curate?

This information is spread across:

* Hydra::AccessControls
* The repository manager YML file
* The application manager YML file

The concerns are partially merged into CanCan's expected [Ability class](https://github.com/projecthydra-labs/curate/blob/master/app/models/concerns/curate/ability.rb)

The enforcement is spread across controllers and views, leveraging both CanCan queries (i.e. `can?(:edit, @work)`)
and inline `if current_user.repository_manager?`.

### How to replace these interactions

## Administrative Context

### Where does this exist in Curate?

No where. This is a yet to be defined concept.