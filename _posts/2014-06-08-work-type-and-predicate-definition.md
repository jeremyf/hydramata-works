---
author:   jeremyf
category: demos
filename: 2014-06-08-work-type-and-predicate-definition.md
layout:   demo
title:    Work Type and Predicate Definition
tags:     demo, work-type, schema
---

Hydramata::Works eschews creating custom classes for each possible type of work (i.e. there is no [Article class as there was in Curate](https://github.com/projecthydra-labs/curate/blob/develop/app/repository_models/article.rb)).
Instead, Hydramata::Works allows [types of works to be arbitrary, defined, and persisted]({{ site.repo_url_file_prefix }}app/models/hydramata/works/work_types/storage.rb).

It is a database-backed means of declaring the suggested structure for implementations of specific types of works.
This means that each institution could define their own suggested structure for an Article work type.

When I say "suggested", I am acknowledging that the actual structure of a given work may be different.
Maybe someone added an additional predicate on ingest to their Article.
Does that mean all Articles should be updated to handle the new predicate?

In other words, I am letting an individual Article be the authority of its own schema; But allowing any suggestions to also have influence.
This works well for RDF but I believe is extensible beyond RDF.

## Example

### Some Diagrams Please

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
       ^                       ^
+-------------+         +--------------+
| Property    + >------ | Predicate    |
+-------------+         +--------------+
       |
       ^
+-------------+
| Value       +
+-------------+
</pre>

A WorkType is a named concept (i.e. Book, Document, Article, BrainScan, etc.).
It has PredicateSets. These are named ordered groupings of Predicates.
A Predicate represents a "well-defined" term that may have an external URI for its definition (DC:Title, FOAF:Age, etc.).

A Work is an instantiation of a WorkType. "Lord of the Rings" would be a Work.
PropertySet are named ordered groupings of Properties.
A Property is composed of a Predicate and Values.

### Persist an Article WorkType in the database.

```ruby
Hydramata::Works::WorkTypes::Storage.create!(identity: 'article', name_for_application_usage: 'article')
```

By itself this isn't very helpful.

Below are the steps to create an Article work type with [DC:Title](http://purl.org/dc/terms/dc_title) and [DC:Alternate](http://purl.org/dc/terms/dc_alternate) predicates.
The presentation sequence of predicates are also defined.
For good measures I've added the validation that the DC:Title will always be required.

```ruby
# Defines the Article Work type.
@article = Hydramata::Works::WorkTypes::Storage.create!(identity: 'article', name_for_application_usage: 'article')

# Defines an arbitrary container for predicates.
@predicate_set = Hydramata::Works::PredicateSets::Storage.create!(identity: 'required', work_type: @article, presentation_sequence: 1, name_for_application_usage: 'required')

# Defines the DC:Title and DC:Alternate predicates; These are reusable by other work types
@title_predicate = Hydramata::Works::Predicates::Storage.create!(
  identity: "http://purl.org/dc/terms/dc_title",
  name_for_application_usage: 'title',
  validations: '{"presence": true}'
)
@alternate_predicate = Hydramata::Works::Predicates::Storage.create!(
  identity: "http://purl.org/dc/terms/dc_alternate",
  name_for_application_usage: 'alternate'
)

# Defines the order in which the predicates will be presented within the :required predicate set.
@predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 1, predicate: @title_predicate)
@predicate_set.predicate_presentation_sequences.create!(presentation_sequence: 2, predicate: @alternate_predicate)
```

When I go to create a new Article, the form has inputs for DC:Title and DC:Alternate.

<img src="{{ site.baseurl }}/images/new-article-form.png" class="img-thumbnail" title="New Article Form" alt="Screen capture of New Article Form in base app">

The above screen grab was from a [custom Rails application](https://github.com/ndlib/predicate-rendering) that uses the Hydramata::Works gem.
Its a scratch pad, but the `#new` action's controller was:

```ruby
def new
  work = Hydramata::Works::Work.new(work_type: 'article')
  presenter = Hydramata::Works::WorkPresenter.new(work: work, presentation_context: :new)
  @work = Hydramata::Works::WorkForm.new(presenter)
end
```

I want to consolidate the above lines so it is not as chatty.
But that is a future goal.

## Supporting specs

If you want to see this in action, please look at the feature spec that [instantiates a work from a persisted work type]({{ {{ site.repo_url_file_prefix}}spec/features/instantiate_work_from_persisted_work_type_spec.rb).
You may also find it helpful to see [how validations are applied]({{ site.repo_url_file_prefix}}spec/features/a_form_for_a_given_work_with_predicate_level_validations_spec.rb).

## Notes

An astute reader will notice that there is some duplication in the :identity and :name_for_application_usage attributes.
I'm working out the kinks in this concept.

I am separating the persistence logic from the structural logic.
[Hydramata::Works::WorkType]({{ site.repo_url_file_prefix }}app/models/hydramata/works/work_type.rb) defines the data structure. This data structure is used throughout much of Hydramata::Works.

[Hydramata::Works::WorkTypes::Storage]({{ site.repo_url_file_prefix }}app/models/hydramata/works/work_types/storage.rb) is responsible for persisting and reifying the Work Type data structure.
Think of it as an intermediary between the actual WorkType data structure and the database.

As an added bonus to the development, by defining a very lightweight WorkType that is not an ActiveRecord model, the concerns are separated and the tests can run faster.
Which means new development can go faster as can refactoring.