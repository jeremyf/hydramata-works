---
author:   jeremyf
category: demos
filename: 2014-07-16-explaining-the-suggested-structure.md
layout:   demo
title:    Explaining the Suggested Structure
tags:     demo, design, development, modeling
---

*Note: This is aspirational, but getting closer each day.*

I've spoken about the [suggested structure](../work-type-and-predicate-definition).
Now an example.

Let's assume we have a work type of `Article`.
And that `Articles` have a `title` predicate that is presented in the `required` predicate set.

Now I create a new `Article` with a `title` of "A Lengthy Treatise".
Then if I were to display that  `Article` it may look something like this:

```
Article
  Required:
    Title: A Lengthy Treatise
```

Now, someone with great power - a metadata specialist - decides that my `Article` should have a `location` predicate. So they amend my `Article` adding the predicate `location` with a value of "Notre Dame, IN".

How did they do that? They have great power!
The `location` predicate was already defined in the system.
And based on their role, new predicates could be appended to a work.

Now, when I go to view my `Article` it might now look something like this:

```
Article
  Required:
    Title: A Lengthy Treatise
  Additional Predicates:
    Location: Notre Dame, IN
```

Where did this `Additional Predicates` come from?
Hydramata::Works, as it was retrieving the object parsed the object and found new predicates that it could handle.
But, the suggested structure of the `Article` work type doesn't indicate where the predicate should be displayed.
So the rendering engine drops it into the proverbial junk drawer.

The ability to append predicates to any given work becomes a privilege that could be granted to one or more people.

As could the ability to edit a given predicate. Or display that predicate.