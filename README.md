# Hydramata::Work

[![Version](https://badge.fury.io/rb/hydramata-work.png)](http://badge.fury.io/rb/hydramata-work)
[![Build Status](https://travis-ci.org/jeremyf/hydramata-work.png?branch=master)](https://travis-ci.org/jeremyf/hydramata-work)
[![Code Climate](https://codeclimate.com/github/jeremyf/hydramata-work.png)](https://codeclimate.com/github/jeremyf/hydramata-work)
[![Coverage Status](https://img.shields.io/coveralls/jeremyf/hydramata-work.svg)](https://coveralls.io/r/jeremyf/hydramata-work)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/github/jeremyf/hydramata-work/master/frames/)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

See the [High Level Stories regarding the Hydramata::Work component](./documents/high-level-stories.md).

Responsible for providing a well defined data-structure to ease the
interaction between differing layers of an application.

* Persistence Layer
* In Memory
* Rendering/Output Buffer

## Hydramata::Work's Vision

[CurateND](http://curate.nd.edu) allows for the uploading five Work types: Article, Dataset, Document, Image, and Senior Thesis.
Four of the five Work Types (not including Senior Thesis) have their metadata attributes defined in an [application profile](http://ndlib.github.io/metadata_application_profile/templates/). There is a lot of overlap regarding the metadata elements that are rendered.

One of the goals of the Hydramata::Work project is to allow institutions to create arbitrary Work types that are somewhat arbitrarily comprised of well-defined metadata element predicates.
These predicates can be defined in [various ontologies](http://en.wikipedia.org/wiki/Ontology_(information_science)). Examples include [Dublin Core](http://dublincore.org/documents/dcmi-terms/), [Friend of a Friend](http://www.foaf-project.org/), [schema.org](http://schema.org/docs/schemas.html), etc.

Predicates can be complex in nature. Consider a "name" predicate. It could be comprised of "given_name", "surname", and several other elements [see Personal Names Around the World](http://www.w3.org/International/questions/qa-personal-names).

The Hydramata::Work project is positioning to allow for:

* The dynamic creation of different work types
* Assigning suggested predicates to the work types
* And declaring a recommended presentation structure for the work types
* Expose defaults for predicate values within a work type context
* Expose validation for predicate values

At present, the core functionality is being built out.

## Prototypical Story

### Bootstrapping:

* Get a Rails app up and running
* Include the Works gem
* Run the Hydramata::Work generators
  * Will need to create Work Type, Presentation Structure, and Predicates
* Create controller for a new work

### Epic - Create HTML form for new Work context

#### Story - Article

For each fieldset of the Article,

  * Define semantically well-formed HTML markup (ie proper classes, ids, data-attributes, and aria-roles)
  * Internationalize captions

Then for each of the [Article predicates](http://ndlib.github.io/metadata_application_profile/templates/#article_template)

  * Define semantically well-formed HTML markup (ie proper classes, ids, data-attributes, and aria-roles). CSS is out of scope.
  * Internationalized labels and hints
  * Assume multi-value inputs as default
  * Consumers are: a person, javascript, and accessibility tools.
  * Write a spec to verify that the view is well-formed

  For the first pass, done will be worked out betweens the Dans.

## Top Level Features

These features reflect the movement of data from one layer to another.
In each layer, there is a concept of a Work and its data structure.

- [x] Fedora -> Memory
- [x] Memory -> Show HTML
- [x] Memory -> Show JSON
- [x] Memory -> Edit HTML
- [ ] Database -> Memory
- [ ] Solr -> Memory
- [ ] Memory -> Fedora
- [ ] Memory -> Database
- [ ] Memory -> Solr
- [ ] Memory -> New HTML
- [ ] Memory -> Solr Document
- [X] UI Input for New -> Memory
- [ ] UI Input for Edit -> Memory
- [ ] Validation in Memory Object

## Low Level Tasks

These should not be considered exhaustive.
But are instead a parking lot that may be cleared or added to.

- [X] Default entity rendering to include work_type as one of the partial
      prefixes.
- [X] Default fieldset rendering to include work_type and fieldset name as the
      partial prefixes.
- [X] Default fieldset rendering to include work_type, fieldset name, and
      predicate name as the partial prefixes.
- [X] Create Work Type persistence
- [X] Create Work Type conversion
- [X] Create Work Type presentation structure persistence
- [X] Integrate presentation structure persistence with construction of in memory objects for presentation
- [X] Remove some duplication of Work Type and Predicate (moving towards a Definition concept?)
- [X] Create some rudimentary seeds for Work Types
- [X] Create some rudimentary seeds for Work Types presentation structure
- [X] Create some rudimentary seeds for Predicates
- [ ] Disambigutate identity vs. name for application usage
- [ ] Allow for the declaration of validations for a given Predicate
- [X] Improve internationalization support by providing a better key path.
- [X] Add view tests for show templates
- [ ] Add view tests for edit templates
- [ ] Reify an object from persistence then apply value changes
- [ ] Review view rendering path options; Presently the top level work type is created.
- [ ] Add PresentationStructure builder by WorkType; This is done by interrogating the
      data storage.
- [ ] Conversion for Entity to EntityPresenter; Or Presenter() conversion
- [X] Create a NullWorkType concept.
      It would be helpful to create a Null Work Type, so our application doesn't choke.
- [X] Add internationalization for Work Type contexts:
  - [X] Work type name
  - [X] Work type description
  - [X] Work type verbose description (fallback to description)
- [X] Add internationalization for Predicate Set
  - [X] Predicate set name
  - [X] Predicate set description
  - [X] Predicate set verbose description (fallback to description)
- [X] Add internationalization for Predicate
  - [X] Predicate label
  - [X] Predicate description (hint)
  - [X] Predicate verbose description (fallback to description)
