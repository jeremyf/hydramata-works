# Hydramata::Works

[![Version](https://badge.fury.io/rb/hydramata-works.png)](http://badge.fury.io/rb/hydramata-works)
[![Build Status](https://travis-ci.org/ndlib/hydramata-works.png?branch=master)](https://travis-ci.org/ndlib/hydramata-works)
[![Code Climate](https://codeclimate.com/github/ndlib/hydramata-works.png)](https://codeclimate.com/github/ndlib/hydramata-works)
[![Coverage Status](https://img.shields.io/coveralls/ndlib/hydramata-works.svg)](https://coveralls.io/r/ndlib/hydramata-works)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/github/ndlib/hydramata-works/master/frames/)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Responsible for providing a well defined data-structure to ease the interaction between differing layers of an application:

* Persistence Layer
* In Memory
* Rendering/Output Buffer

## Project Homepage

Are you looking for Demos and High Level Documentation? Take a look at the [Project Homepage](https://jeremyf.github.io/hydramata-works).

Are you looking for the Code and how to Get Started? Then **this is the right place**.

## Getting Started

Presently Hydramata::Works is a work in progress, and very much not ready for production usage.

But I would encourage you to:

1. Clone the repository: `git clone https://github.com/ndlib/hydramata-works.git hydramata-works`
1. Change to the repository's directory: `cd hydramata-works`
1. Install the base dependencies: `bundle install`
1. Run the default rake task: `rake`

The rake task will build the internal rails application and run all of the tests.

Once you have the `spec/internal` directory built, you can run `rspec` or `rake spec:all`.

## Data Structure and Definition

<pre>
+-------------+         +--------------+
| Work        | >------ | WorkType     |
+-------------+         +--------------+
       |                       |
       ^                       ^
+-------------+         +--------------+
| PropertySet + >------ | PredicateSet |
+-------------+         +--------------+
       |                       |
       ^                       |
+-------------+         +--------------+
| Property    + >------ | Predicate    |
+-------------+         +--------------+
       |
       ^
+-------------+
| Value       +
+-------------+
</pre>


## Resources

* [Vision of Hydramata::Works](./VISION.md)
* [Contributing Guidelines](./CONTRIBUTING.md)
* [Todo](./TODO.md)
* [Design Documents](./documents/) - as with any documentation these will less and less reflect the state of Hydramata::Works but are a reference point.
* [Test related README](./spec/README.md)
