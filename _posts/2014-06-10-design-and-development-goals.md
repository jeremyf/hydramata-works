# Design and Development Goals

* [High Quality Feature Specs](#High-Quality-Feature-Specs)
* [Dependency Inversion](#Dependency-Inversion)
* [Minimal Number of Public Methods](#Minimal-Number-of-Public-Methods)
* [Explicit Requires](#Explicit-Requires)

## High Quality Feature Specs

I consider a quality spec to be:

* quick to run
* expresses intent
* provides a high percentage of code coverage
* verifies both happy and sad paths
* minimal number of collaborators

For Hydramata::Works, I'm attempting to write most specs in near isolation, except in the case of `./spec/features`.

The Feature Specs is where I verify the high level features.
This involves slower tests, multiple collaborators.

I also want my feature specs output to be reasonable meaningful for developer-minded people.
As a developer, I want you to get helpful information from `rspec --format documentation spec/features/` (or `rspec -f d spec/features/` for short).

## Dependency Inversion

As you sift through the code, you will find lots of Dependency Inversion (one of the five principles for [SOLID Object Oriented Design](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)).

Below is a quick example to demonstrate the pattern I'm using.

```ruby
class MyClass
  def initialize(collaborators = {})
    @builder = collaborators.fetch(:builder) { default_builder }
  end

  private
  def builder
    @builder
  end

  def default_builder
    require 'builder'
    Builder
  end
end
```

In doing this, I'm able to test in isolation, which is one of my design goals.

If I find that a class is collaborating with another class, I stop extract that collaboration into the above pattern.
In doing this I'm also helping to declare the expected interface.

## Minimal Number of Public Methods

For behavior related classes (i.e. not Data Structures), I want as few public methods as possible.
Two(2) methods is the goal: `#initialize` and `#call`.

The `#initialize` method establishes the collaborators.
The `#call` method does the work.

## Explicit Requires

Rails provides a lot of magic related to loading dependencies.
I have ignored its autoload magic in most cases.
I prefer to instead use explicit requires.

This means collaborators are declared as part of the require statement.
It also means that most of my tests can be run in isolation without needing to load the entire Rails microcism.

See [spec/spec_fast_helper.rb](/spec/spec_fast_helper.rb) for further details.

I verify the isloation by running all of the tests via the [`./run_each_spec_in_isolation` command](/run_each_spec_in_isolation).

## Declare, Expose, and Enforce Interfaces

Given that this is a foundational gem, I want to make sure that the core objects have a clear interface and adhere to them.
I also want to expose a means for implementors to verify that their objects adhear to that interface.

Thus I've taken the time to create Linters.
These are analogous to [ActiveModel::Lint::Tests](http://api.rubyonrails.org/classes/ActiveModel/Lint/Tests.html).
At present this is a mixed bag.

The more terse 'implments_<klass>_interface' matchers are easiest to include inline.
I will perhaps migrate the ones that use shared_behavior.

The linters can be found in [`./lib/hydramata/works/linters.rb`](/lib/hydramata/works/linters.rb) and [`./lib/hydramata/works/linters/`](/lib/hydramata/works/linters/).

The linters are in `./lib` so those using the Hydramata::Works gem can use them as well.

## Separating Data Structure and Persistence Negotiation

I have worked with ActiveRecord for a very long time.
I have done bad things with ActiveRecord.
Most of them involve adding lots of :after_save callbacks and service type behavior into the class.

The same is true for ActiveFedora.

I wanted to break this pattern. Inspired by [Bryan Helmkamp](https://twitter.com/brynary) blog post on [decomposing fat ActiveRecord models](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/), I went about keeping things very much separate.

In fact, for the initial development, I used plain old ruby objects (POROs) with attributes defined via `:attr_accessor` declarations.
It was invigorating! And development was fast.

I didn't have to mess around with ActiveRecord type tests.
I didn't need to keep migrating a schema.

I could focus on how the data structure would be used through out the various services.

This has been inspired, in part by [Virtus](https://github.com/solnic/virtus) and [Lotus::Model](https://github.com/lotus/model)

## Presenters, Forms, Parsers, Renderers, Wranglers

There are lots of first class concepts that are introduced in this application.
I'm exploring what this means, but I know that I don't want a "app/services" dumping ground.

Presenters are things that I've needed to explore for a long time, but haven't.
I opted not to use any of the existing presenter gems. [Draper](https://github.com/drapergem/draper) and [Display Case](https://github.com/avdi/display-case) being the two that popped to mind.

The reason for not using other presenter gems is in part because of the headache of the arbitrary work object.
My cursory investigation of Draper led me to believe that a Presenter maps to a particular Class (i.e. an ArticlePresenter for an Article).
But Hydramata::Works main data structures don't have that.

I also wanted to explore the idea that a presenter should be able to render itself.
This has exposed the concept of rendering with diminishing specificity; something that I believe will be useful in the adpotion of Hydramata::Works.