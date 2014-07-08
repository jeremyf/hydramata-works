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
