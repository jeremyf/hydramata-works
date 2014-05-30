# High-level Stories

Below are stories that are supported in the `./documents` directory.

## Must Have

### Transform in memory Work object to Show HTML Document

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

* Transform Database object to in memory Work object
* Transform Solr object to in memory Work object
* Transform in memory Work object to SOLR Document
* Transform in memory Work object to New HTML Document
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