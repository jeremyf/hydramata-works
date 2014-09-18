# Lecture Notes

## Background of Hydramata::Works

* "Cracked Rear View" Hootie and the Blowfish

### Rails

Rails espouses Convention over Configuration;
Yet it is a very configurable framework.
Why? Because lots of people use it.

Sometimes convention doesn't work.
Configuration is necessary.

> So they can, if they please, choose to follow a carefully curated set of opinions on how best to develop web applications with Rails and trust that it'll be good.
> Just like Rails itself is a carefully curated collection of APIs and DSLs.
> Follow a carefully curated set of opinions on how best to develop web applications with Rails and trust that it'll be good.
> Just like Rails itself is a carefully curated collection of APIs and DSLs.
> -- [David Heinemeier-Hansson](http://david.heinemeierhansson.com/2012/the-parley-letter.html)

But, lets assume convention is our *modus operandi*.
Conventions change overtime; Convention is the manifestion of an ever shifting understanding of the problem space that Rails addresses.

> Rails once valued convention over configuration, a very long time ago, but today values
> *curation over configuration*
> -- [Giles Bowkett](http://gilesbowkett.blogspot.com/2013/02/the-lie-of-convention-over-configuration.html)

@TODO - What does this mean?

### Hydra Philosophies

> So why care about compliance?
> Well firstly, by sticking to the ‘rules’, more importantly maybe sticking to our approach, you can be assured of community support to assist your development process.
> We will all know in general terms what it is you are trying to achieve and may be able to offer advice based on the way we dealt with similar problems.
> Secondly, we hope that by conforming to standard patterns it will be possible for you to maybe adopt further developments with a minimum of pain – these may be additional Hydra heads or applications outside our framework but which assume ‘Hydra-compliant’ objects.
> It goes without saying, that Hydra’s gems largely assume Hydra compliance.
> -- [Hydra Design Principles](http://projecthydra.org/design-principles-2/)

As a Hydra adopter, how do you feel about adopting further development from partners?
How do you feel about diving in and helping others?

Again, are we doing a good job of sharing?

I have been hesitant to bring more dependencies from Hydra into our development.
There are so many moving parts.
Parts that I've created.
Parts that pile upon classes that are already overworked.

What has been your experience of upgrades?

As a community are we investing in the curation of tools for digital repositories?
Are the tools that we are curating understood? Maintainable? Robust? Flexible? Durable?

This is a long game that we are playing in digital repositories.
Are we up for that wear and tear? Are our tools?

### Notes

* Sufia -> Curate -> Hydramata::Works +
* Identifying the Community Problems
  * Who here is actively working on a yet to be launched Hydra app?
  * Who here has a Hydra application that you consider to be out of date?
    * What are your plans on upgrading?
    * Are those steps clear?
  * Who here is afraid to stop running on the Hydra treadmill?
* Request for configuration at many levels
  * Generally:
    * How we describe our metadata
    * How we move our metadata and artifacts
  * Specifically:
    * Types of Works by Institution
      * A Document at one institution may have different predicates than another institution
    * Types of Predicates by Institution
      * A Predicate at one institution may be more or less comprehensive than another institution
    * Types of Works by Date
      * Our understanding of data changes overtime
      * We operate in a somewhat schema-less ecosystem (Fedora documents)
    * Internationalization by Institution
      * At one institution we may use different language to explain the same concept; Nevermind that it may all be English.
    * Types of Workflows by Institution
      * Sequence of events that fire may vary
      * What events fire may vary
* A Desire for a Turn Key Solution
  * Sidebar: Why is this necessary?
  * Sidebar: What is the reason?
  * Hydra is a framework. It works if you commit to keep working on it.
    * This runs contrary to a Turn Key Solution
  * Are we to a point where we can share larger concepts? Applications?

## Personal Observations over the past 2 Years

* "Well How Did I Get Here?" Talking Heads

> It is “free” as in “free kittens,” not “free beer” – you still have to maintain it, and that’s where the overhead with software comes in.
> -- [K.G. Schneider](http://freerangelibrarian.com/2006/10/16/south-africa-slis-follow-up-1-michael-stephens-web-20-and-libraries/)

* Are we doing a good job sharing?
  * I asked this question at LDCX 2014.
    It was [a fruitful conversation](https://github.com/ldcx/ldcx-2014/blob/master/sessions/improving-sharing.md).
  * My short answer is not yet, though there are signs.
* A tacit understanding that if you step off the hydra train, you are left behind and must work hard to catch up
  * [Notre Dame's Pain Points of Upgrading](http://ndlib.github.io/hydramata-works/demos/addressing-our-pain-points/)
* Controller methods suck to test (this is an observation from the past 7 years of Rails development)
  * There are so many concerns to juggle
* There is a plea for updating the documentation
  * The tutorial falls behind
  * The "how do I modify X,Y, and Z?"
  * ...an effort is made...
  * ...but it quickly ages.
* Where is this train going?
  * Are we spending enough time introspecting on how we are doing this stuff?
  * And who would do this?
  * Design by Committee? or Dictatorship? or Tribal Warlords?
* Testing Hydra is slow going; I don't trust mocking my Fedora interactions because I perceive ActiveFedora as volitale
  * Its trying to keep up with Rails ActiveRecord features

### Is the ActiveRecord pattern the correct Pattern for Long Term preservation concerns

> Active Records are special forms of DTOs [Data Transfer Objects]. They are data structures with public variables; but they typically have navigational methods like *save* and *find*. Typically these Active Records are direct translations from database tables, or other data sources.
>
> Unfortunately we often find that developers try to treat these data structures as though they were objects by putting business rule methods in them.
> This is awkward because it creates a hybrid data structure and an object.
>
> The solution, of course, is to treat the Active Record as a data structure and to create separate objects that contain the business rules and that hide their internal data (which are probably just instance of the Active Record).
>
> -- Martin, Robert C. "Clean Code: A Handbook of Agile Software Craftsmanship (Robert C. Martin Series)" pp

ActiveRecord pattern requires/assumes keeping model and schema in-sync.
Rails mitigates this synchonization issue by introspection on the database's table.
ActiveFedora does not provide such a luxury.

Traditionally, Rails pushed ActiveRecord objects towards Fat Models.
I blame [Fat Models, Skinny Controllers](http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model).
But I am not without blame.
I jumped on the Fat Models train.

I remember early in Rails development having MVC related arguements about where things should go.
My coworker said "In the controller" and I said "In the model."

It turns out we were both wrong.
But we didn't have a noun to attach the behavior to.
We were talking about a Query object; Something that finds the objects that we need.
In other cases we needed a Command object; Something that transforms an object.

Consider the more general statement from Robert Martin.

> Procedural code (code using data structures) makes it easy to add new functions without changing the existing data structures.
> OO code, on the other hand, makes it easy to add new classes without changing existing functions.
>
> The complement is also true:
>
> Procedural code makes it hard to add new data structures because all the functions must change.
> OO code makes it hard to add new functions because all the classes must change.
>
> -- Martin, Robert C. "Clean Code: A Handbook of Agile Software Craftsmanship (Robert C. Martin Series)" pp 97

* What would Hydra look like without Fedora? Blacklight? Solr?
* Is direct deposit into Fedora the best way to do these things?
* Asynchronous is powerful
* We want to share code, but its free as in kittens; I don't want to be a crazy cat person @MUST

With these observations and requirements Hydramata::Works embarked on a journey

### As developers we are charged with solving problems?

* What are the problems of Hydra development?
  * Documentation
  * Reusability
  * Updatability

### Addressing the size of the object graph. @MUST

Think about a map?
If I want to understand my county, I want a county map.
If I want to understand the geography the United States, I don't need to see every city, road, river, park, etc.
I want guide posts.

* What is my entry point(s) into the stack?
* Is there a clear and compelling entry point into the stack?
* By convention Rails provides 3 entry points
  * Routes
  * Controllers
  * Models
* I am proposing the ServiceMethods module
  * This is inspired by the late Jim Weirich's Wyriki repository

I have never regretted creating a small class to do a task.
I may factor it into a larger class. But that is rare.
When exposed to lots of small classes *all at once* it is harder to understand what is happening.

## Dive into Hydramata::Works

* Two Types of Classes
  * Data Structures
    * Many public methods, getters and setters
    * Idempotent and immutable-ish
  * Functions
    * Does things with data structures
    * Two-ish public methods: #initialize and #call
      * Transform from persistence to a data structure
      * Push a data structure to persistence
      * Perform validations
* Runners, Services, Presenters
  * Runners - Analogous to a command that runs in a command shell; It is run by as part of a controller's action.
    A controller action that is abstracted to be run from the command line.
    It will make use of a service method (or two) and provide custom responses based on the calls to the services
  * Services - Stitches together the method calls for a Runner; A good candidate for entry point into reading the code.
  * Presenters - Wraps a data structure for UI interaction
* Diminishing Specificity
  * View rendering
    * Customize how Work Type, Predicate Set, Predicate are rendered
      * Render the :attachment predicate as a :file
      * Render the :document work type container as a :cool_presentation_object
        * But each underlying layer can have its own customization
      * Leaves open the option for easy custom rendering by identifier
        * I want PID sufia:123abc to render using the "Project Hydra"
  * Translation services
    * Similar to views in that you can specify the translation key
    * Attach arbitrary translations to each level
  * @TODO - How to do this for translations and views? How to debug?
* Configuration at numerous levels
  * Change where things are persisted at run-time
    * Take Fedora down for maintenance while capturing deposits into a database
    * Walk data from a Database to Fedora or vice-versa
    * Yes, you will need to write code, but the concern is small (SOLID principles in play)
* Favoring composition over inheritence
  * ("Composition over inheritance is a design principle that gives the design higher flexibility, giving business-domain classes and more stable business domain in the long term.")[http://en.wikipedia.org/wiki/Composition_over_inheritance]
  * Focus on many small collaborators and compose larger containers
    * Made easier by thinking of two primary types of objects: Data structures and Functions

## Methodology @APPENDIX

* Create a feature branch
  * Write a feature spec
    * What high-level thing do I need to see happen
    * What is the input and output
    * Don't think about the GUI, think about the UI
    * This will be failing for a very long time
    * Give the feature a home
      * The Service Method is a great place to start
      * Though a Runner might also work; Its just that there are more moving parts
    * Get the test failing
    * Commit your code!
    * Take a break
    * Address the steps that need to happen
      * For Each step is a Function (input transformed to output)
        * Explore the first step
          * Write unit tests surrounding this
          * Explore the collaborators; data structures, other functions
        * Get the unit tests passing
    * See the test pass
    * Commit your code!
    * Take a break
    * Revisit your code
      * Are your tests expressive?
      * Are your nouns and verbs meaningful?
      * Do your classes have a single responsibility? A single reason to change?
        * Can you write a meaningufl two sentences for the documentation?
      * Have you kept commands and queries separate?
        * When you are going to collaborate with a Function class, [separate the receiver determination and the command call](https://github.com/ndlib/hydramata-works/blob/master/app/services/hydramata/works/to_persistence/database_coordinator.rb)
  * [Write conversion functions](https://github.com/ndlib/hydramata-works/blob/master/lib/hydramata/works/conversions/work_type.rb)
    * Convert a data structure type object to another. I took the time to do this and I love it!
* Pay attention to Code Coverage
  * The goal is not to have high code coverage; It is a by product of well tested code
  * Well tested code is well-documented
  * Well documented code is a marker of adoption

## Tests are Mandatory

> The unit tests are documents.
> They describe the lowest-level design of the system.
> They are unambiguous, accurate, written in a language that the audience understands, and are so formal that they execute.
> They are the best kind of low-level documentation that can exist.
> What professional would not provide such documentation?
> -- Martin, Robert C. "The Clean Coder: A Code of Conduct for Professional Programmers (Robert C. Martin Series)"

Our tests are documentation.
Commit to well-documented code.
Commit to an area of the code being well documented.

> “But I can write my tests later,” you say.
> No, you can’t.
> Not really.
> Oh, you can write some tests later.
> You can even approach high coverage later if you are careful to measure it.
> But the tests you write after the fact are *defense*.
> The tests you write first are *offense*.
> After-the-fact tests are written by someone who is already vested in the code and already knows how the problem was solved.
> There’s just no way those tests can be anywhere near as incisive as tests written first.
> -- Martin, Robert C. "The Clean Coder: A Code of Conduct for Professional Programmers (Robert C. Martin Series)"

Write your tests before hand.
In doing so, I enter the mindset of "How will I assert what I am doing is correct?"
I think not in the solution but how I will "prove" the solution.

> Am I suggesting 100% test coverage?
> No, I’m not *suggesting* it.
> I’m *demanding* it.
> Every single line of code that you write should be tested.
> Period.
> -- Martin, Robert C. "The Clean Coder: A Code of Conduct for Professional Programmers (Robert C. Martin Series)"

If lines of code aren't tested they aren't documented.
They are subject to change without a change in documentation.

> The goal is not coverage.
> We are not going to prove out every business rule and every execution pathway with these tests.
> Rather, the goal is to ensure that the system behaves well under human operation and to creatively find as many “peculiarities” as possible.
> -- Martin, Robert C. "The Clean Coder: A Code of Conduct for Professional Programmers (Robert C. Martin Series)"

We want well-documented code.
And all of the code should be documented.
Code coverage is a happy by product of this.

## Inspirations

* Jim Weirich
  * [Wyriki](https://github.com/jimweirich/wyriki)
  * [Dudley](https://github.com/jimweirich/dudley)
* Robert Martin
  * [SOLID Object Oriented Design](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design))
    * Single Responsibility
    * Open/Closed
    * Liskov Substitution - Objects replaceable with instances of their subtypes
    * Interface Segregation
    * Dependency Inversion - Depend upon Abstractions. Do not depend upon concretions.
  * [Clean Coder](http://www.amazon.com/The-Clean-Coder-Professional-Programmers/dp/0137081073)
  * [Clean Code](http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
* Avdi Grimm
  * [Confident Ruby](http://www.confidentruby.com/)
  * [Naught](https://github.com/avdi/naught)
  * [Display Case](https://github.com/avdi/display-case)
* Sandi Metz
  * [Practical Object-Oriented Design in Ruby](http://www.poodr.com/)
  * [Four Rules](http://robots.thoughtbot.com/sandi-metz-rules-for-developers)
* Luca Guidi
  * [Lotus Ruby Framework](http://lotusrb.org/)
* Corey Haines
  * [Understanding the Four Rules of Simple Design](https://leanpub.com/4rulesofsimpledesign)
  * [ActiveRecord Spec Helper](https://gist.github.com/coreyhaines/2068977)
* Code Climate
  * [7 Patterns to Refactor Fat ActiveRecord Models](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/)
* Elisabeth Freeman & Eric Freeman
  * [Head First Design Patterns](http://www.headfirstlabs.com/books/hfdp/)
* Bertrand Meyer
  * [Command Query Separation](http://en.wikipedia.org/wiki/Command%E2%80%93query_separation)
* Nick Sutterer
  * [Representable](https://github.com/apotonick/representable)
  * [Reform](https://github.com/apotonick/reform)