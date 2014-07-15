---
author:   jeremyf
category: demos
filename: 2014-06-15-interacting-with-fedora.md
layout:   demo
title:    Interacting with Fedora
tags:     demo, rails, design, development, fedora, rubydora
---

## Dynamically Building the Model

Earlier, I had wrote about [Work Types](../work-type-and-predicate-definition).
Hydramata::Works provides a way to expose the suggested structure of a Work Type.
However, it allows the actual work to also define its schema.

This is done via the [Fedora Wrangler]({{ site.repo_url_file_prefix}}/app/wranglers/hydramata/works/fedora_wrangler.rb).
In short, the Fedora Wrangler:

1. Finds the Fedora object
1. Determines the object's work type
1. Parses the object's datastreams

Parsing the datastream is handled by the [DatastreamParser]({{ site.repo_url_file_prefix }}/app/parsers/hydramata/works/datastream_parser.rb); which is responsible for finding the correct parser for that data stream.
The correct parser could be based on:

* Work type
* Datastream content type
* Or other arbitrary parameters

Think for a moment about this.
It would be possible to check the datastream last updated timestamp and retrieve the correct parser for that point in time.

No more migrations!

And what is done for Datastreams is then done for Predicates.

## Why This and Not ActiveFedora

Because ActiveFedora attempts to model each and every work type.
And those models become very challenging to share amongst institutions.
In part because the data and behavior are comingled.

It would be possible to develop data-only models for ActiveFedora.
It is not common practice amongst Hydra.
Even so, with ActiveFedora our application is bound by schemas. Which means migrations and deployment changes.

Now that our team at Notre Dame has updated a few Hydra applications we are noticing a pattern.
Our use of ActiveFedora has created pain points in those updates.

This, in part, is because our persistence negotiation logic is wrapped up with business logic, creating super models.
And over time, these models are finicky and inflexible.

## Testing Fedora without Fedora Always Running

I don't like slow tests.
The [tests for Curate are slow](https://travis-ci.org/projecthydra-labs/curate); This happened over time and failing to weed the test suite.
Now one of [my stated design goals for Hydramata::Works is fast running specs](../design-and-development-goals#high-quality-feature-specs).

One of the slow aspects of many Hydra tests is related to Fedora.
Both getting Hydra Jetty spooled up and communicating over HTTP.

This is exacerbated on [Travis CI when it downloads Jetty for each test suite](https://travis-ci.org/projecthydra-labs/curate/jobs/27169086#L1682).

I wanted to be able to have fast tests that retrieve an object from Fedora and parsed into a [Work object]({{ site.repo_url_file_prefix }}/app/models/hydramata/works/work.rb).

So I brought out the [VCR gem](https://github.com/vcr/vcr).

First, I wrote a disposable test in CurateND that retrieved an object from Fedora.
Then I added a VCR imperative to record the GET requests and wrote the output to a [Hydramata::Works fixture cassette]({{ site.repo_url_file_prefix }}/spec/fixtures/cassettes/fedora-object.yml)
And last, I wired up my [Fedora tests to use the cassete]({{ site.repo_url_file_prefix }}/spec/features/fedora_to_in_memory_spec.rb).

Below is the test time for the Fedora tests:

```console
$ rspec spec/features/fedora_to_in_memory_spec.rb
.

Finished in 0.58571 seconds (files took 0.89368 seconds to load)
1 example, 0 failures
```

No more of the regular:

* Wait 90 seconds for Jetty to start
* Create a Fedora object via the HTTP API
* Run the test
* Then destroy any created objects

## Supporting Specs

For further information review [Fedora to In Memory spec]({{ site.repo_url_file_prefix }}/spec/features/fedora_to_in_memory_spec.rb).
