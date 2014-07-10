# Hydramata::Works

[![Version](https://badge.fury.io/rb/hydramata-works.png)](http://badge.fury.io/rb/hydramata-work)
[![Build Status](https://travis-ci.org/jeremyf/hydramata-works.png?branch=master)](https://travis-ci.org/jeremyf/hydramata-work)
[![Code Climate](https://codeclimate.com/github/jeremyf/hydramata-works.png)](https://codeclimate.com/github/jeremyf/hydramata-work)
[![Coverage Status](https://img.shields.io/coveralls/jeremyf/hydramata-works.svg)](https://coveralls.io/r/jeremyf/hydramata-work)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/github/jeremyf/hydramata-work/master/frames/)
[![APACHE 2 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE)

Responsible for providing a well defined data-structure to ease the interaction between differing layers of an application:

* Persistence Layer
* In Memory
* Rendering/Output Buffer

## Getting Started

Presently Hydramata::Works is a work in progress, and very much not ready for production usage.

But I would encourage you to:

1. Clone the repository: `git clone https://github.com/jeremyf/hydramata-works.git hydramata-works`
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
