The audience for (most of) the specs that verify the feature is a developer.

RSpec with a statement of target audience for each spec (i.e. product_owner: true).

# To Render a New Work's SIP Form

For the requested work_type
  Instantiate a work with a presentation structure
For each fieldset in the instatiated work's presentation structure
  For each property key (predicate) in the fieldset
    Render property key with Work's property

## Done Looks Like

```gherkin
Given work_type 'Article' has the following presentation structure:
    | fieldset    | property_key
    | :required   | [['DC:TITLE', multi_value: true]]
    | :optional   | [['DC:ABSTRACT', multi_value: false]]
When I request an HTML form for a new 'Article'
Then I should see a well-structured output with CSS selectors:
    | css_selector
    | .required .dc-title.multi_value input.value
    | .optional .dc-abstract input.value
And in the response document the .required container preceeds the .optional container.
```

# To Submit a Work's SIP Form

This is a PO-level feature.

## Done Looks Like

```gherkin
Given I have a valid form for a work_type
When I submit the form
Then a SIP is created with a unique PID
And the SIP is submitted for processing
And a :created response is issued
```

# To Render a Work's SIP

For the requested PID
  Find the work in the database and assign the work's properties
For each fieldset in the work's presentation structure
  For each property key (predicate) in the fieldset
    Render property key with Work's property

## Done Looks Like

```gherkin
Given a PID that exists in the database
And it has the following serialized structure properties:
    {'DC:TITLE' => ['My Book', 'A Lengthy Treatise'], 'DC:ABSTRACT' => 'Lots of Words'}
And its work_type of Article has a presentation structure of:
    | fieldset    | property_key
    | :required   | [['DC:TITLE', multi_value: true]
    | :optional   | ['DC:ABSTRACT']
When I request an HTML version of that PID
Then I should see a well-structured output with CSS selectors:
    | css_selector                           | text_value
    | .required .dc-title.multi_value .value | "My Book"
    | .required .dc-title.multi_value .value | "Lengthy Treatise"
    | .optional .dc-abstract .value          | "Lots of Words"
And in the response document the .required container preceeds the .optional container.
```

# To Render a Work's AIP

For the requested PID
  Find the work in Fedora and assign the work's properties
For each fieldset in the work's presentation structure
  For each property key (predicate) in the fieldset
    Render property key with Work's property

## Done Looks Like

```gherkin
Given a PID that exists in Fedora
And it has the following RDF properties:
    | predicate   | object
    | DC:TITLE    | My Book
    | DC:TITLE    | A Lengthy Treatise
    | DC:ABSTRACT | Lots of Words
And its work_type of Article has a presentation structure of:
    | fieldset    | property_key
    | :required   | ['DC:TITLE']
    | :optional   | ['DC:ABSTRACT']
When I request an HTML version of that PID
Then I should see a well-structured output with CSS selectors:
    | css_selector                  | text_value
    | .required .dc-title .value    | "My Book"
    | .required .dc-title .value    | "Lengthy Treatise"
    | .optional .dc-abstract .value | "Lots of Words"
And in the response document the .required container preceeds the .optional container.
```

# A workflow processing a SIP

For queued up SIP Workflow (eg State Machine).
A task is a discreet function that can be run in isolation (i.e. characterize all files associated with this SIP).
A workflow is composed of a sequence of tasks.

**Workflow properties**

A workflow has a unique name
A workflow is comprised of tasks definitions
A task definition is comprised of a unique name

**Outstanding questions**

How is the workflow defined?
How each task is defined (i.e. what is the object interface)?
How is a workflow processed (i.e. how do we run one task, then respond accordingly and start another task)?
How are errors reported/monitored/recovered from?

*Look to [Heracles](https://github.com/ndlib/heracles) for guidance.*

## Done Looks Like

```gherkin
Given a workflow with tasks:
  | task_name | responder
  | :a        | { ok: :b }
  | :b        | { ok: :done }
And `first_task :a`
When the workflow is started
Then task :a is invoked
```

```gherkin
Given a workflow with tasks:
  | task_name | responder
  | :a        | { ok: :b }
  | :b        | { ok: :done }
And `first_task :a`
When task :a is completed with response :ok
Then task :b is invoked
```

```gherkin
Given a workflow with tasks:
  | task_name | responder
  | :a        | { ok: :b }
  | :b        | { ok: :done }
And `first_task :a`
When task :a throws an exception
Then task :b is not invoked
And an error is submitted to the monitoring system
```

```gherkin
Given a task of :generate_derivatives
When the task :generate_derivatives is invoked with a SIP
Then derivatives are generated for each of the SIP's associated primary files (i.e. don't generate derivatives for the derivatives)
And append the derivatives to the SIP's payload
```

```gherkin
Given a task of :run_antivirus
When the task :run_antivirus is invoked with a SIP
And one of the attached files is a virus
Then return a :virus_found
```

```gherkin
Given a task of :run_antivirus
When the task :run_antivirus is invoked with a SIP
And none of the attached files contain a virus
Then return :virus_not_found
```

See the [Raw Object Format repository](https://github.com/ndlib/rof).

```gherkin
Given a task :validate_rof
And a SIP that is will-formed and ready for ingest
When the task :validate_rof is invoked with a SIP
Then return :rof_is_valid
```

# To Index a Work's AIP

SOLR strategy for a given property appears to be the same across work types.
Each Property has a SOLR strategy

# To Represent a Work's Files

If we ask an object for its datastreams, how do we know which ones are files?
Files are attached on children of a Work.
There are manifestations of the Work's files in the datastreams.
Predicate :realization for the File "Work"

# Glossary?

## Work

Responsible for being a container of the data that is persisted in a data store.

* Each work has many properties
* Each property has a key (predicate) and one or more values

## Presentation Structure

Responsible for saying where in the rendering something occurs (eg Title occurs before Author).
Provides logical groupings via Fieldsets (eg the "Required fields" occur before the "Optional fields")

* Each work type has one presentation structure
* Each presentation structure has many fieldsets
* Each fieldset has many property keys

## Fieldset

Responsible for providing logical groupings of properties.
Arbitrarily named; use internationalization (I18n) for name and legend.

## Property Key

## Work's Property

## Renderers

ShowRenderer, EditRenderer, NewRenderer