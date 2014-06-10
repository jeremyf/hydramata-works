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
- [ ] UI Input -> Memory

## Low Level Tasks

These should not be considered exhaustive.
But are instead a parking lot that may be cleared or added to.

- [X] Default entity rendering to include work_type as one of the partial
      prefixes.
- [X] Default fieldset rendering to include work_type and fieldset name as the
      partial prefixes.
- [X] Default fieldset rendering to include work_type, fieldset name, and
      predicate name as the partial prefixes.
- [ ] Create Work Type persistence
- [ ] Create Work Type presentation structure persistence
- [ ] Remove some duplication of Work Type and Predicate (moving towards a Definition concept?)
- [ ] Create some rudimentary seeds for Work Types
- [ ] Create some rudimentary seeds for Work Types presentation structure
- [ ] Create some rudimentary seeds for Predicates
- [ ] Disambigutate identity vs. name for application usage