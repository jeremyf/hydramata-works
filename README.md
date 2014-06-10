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

- [ ] Default entity rendering to include work_type as one of the partial
      prefixes.
- [ ] Default fieldset rendering to include work_type and fieldset name as the
      partial prefixes.
- [ ] Default fieldset rendering to include work_type, fieldset name, and
      predicate name as the partial prefixes.