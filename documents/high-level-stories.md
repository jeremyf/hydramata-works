# High-level Stories

Below are stories that are supported in the `./documents` directory.

## Must Have

### Transform in memory Work object to Show HTML Document

Story points: 3

**Done looks like**

```gherkin
Given a work object with the following propety_set:
  | fieldset  | predicate | value         |
  | :required | :title    | 'Hello'       |
  | :required | :title    | 'World'       |
  | :required | :title    | 'Bang!'       |
  | :optional | :abstract | 'Long Text'   |
  | :optional | :abstract | 'Longer Text' |
  | :optional | :keyword  | 'Programming' |
When I request an HTML version of the work
Then I should have the following css-selectors and text:
  | css_selector               | text        |
  | .required .title .label    | Title       |
  | .required .title .value    | Hello       |
  | .required .title .value    | World       |
  | .required .title .value    | Bang!       |
  | .optional .abstract .label | Abstract    |
  | .optional .abstract .value | Long Text   |
  | .optional .abstract .value | Longer Text |
  | .optional .keyword .label  | Keyword     |
  | .optional .keyword .value  | Programming |
```

### Transform in memory Work object to New HTML Document

Story points: 4

***Done looks like**

```gherkin
Given a work object with the following propety_set:
  | fieldset  | predicate | value         |
  | :required | :title    | 'Hello'       |
  | :required | :title    | ''            |
  | :optional | :abstract | ''            |
  | :optional | :keyword  | ''            |
When I request an HTML version of the work
Then I should have the following css-selectors and text:
  | css_selector                                        | text       |
  | fieldset.required.caption                           | 'Required' |
  | .required .title label.label                        | 'Title'    |
  | .required .title input.value[name=work[title]       | 'Hello'    |
  | .required .title input.value[name=work[title]       | ''         |
  | fieldset.optional.caption                           | 'Optional' |
  | .optional .abstract input.value[name=work[abstract] | ''         |
  | .optional .keyword input.value[name=work[keyword]   | ''         |
  | .optional .keyword input.value[name=work[keyword]   | ''         |
  | .optional .keyword input.value[name=work[keyword]   | ''         |
```

## Parking Lot

* Define a Work type's suggested predicates
* Define a Work type's presentation structure
* Define an abstract Predicate
* Transform Database object to in memory Work object
* Transform Solr object to in memory Work object
* Transform in memory Work object to SOLR Document
* Transform in memory Work object to Edit HTML Document
* Transform in memory Work object to Show JSON Document
* Transform user input from Edit Form to in memory Work object
* Transform user input from New Form to in memory Work object
* Write in memory Work object to Database

## Nice to Have

* Transform Fedora object to in memory Work Object
* Transform in memory Work object to New JSON Document

## There are Small Work Items

* Predicate parsers and coercers
* Datastream parsers and coercers