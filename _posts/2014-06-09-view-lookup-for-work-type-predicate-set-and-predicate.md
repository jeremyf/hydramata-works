---
author:   jeremyf
category: demos
filename: 2014-06-09-view-lookup-for-work-type-predicate-set-and-predicate.md
layout:   demo
title:    View Lookup for Work Type, Predicate Set, and Predicate
tags:     demo, rails, view_paths
---

Building on the [idea that Hydramata::Works allows the definition of arbitrary work types and predicates](./work_type_and_predicate_definition.md), I'm going to go into the view rendering.

## Introduction to Rails View Paths

Out of the box Rails provides the concept of view paths.
In short, a Controller's view paths defines the order in which the Controller attempts to find the correct template for rendering.

As a Rails Engine, Hydramata::Works injects a view path into any mounting application's default view paths.
Below is the view paths for the [custom Rails application](https://github.com/ndlib/predicate-rendering) that utilizes Hydramata::Works.

```ruby
[
  "RAILS_ROOT/app/views",
  "REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views"
]
```

Its more complicated than that.
I am omitting template options for :language, :variant, :format, and :builder.
But I'll gloss over that.

When the application goes to render a Works controller's show action, Rails checks does `RAILS_ROOT/app/views/works/show` exist?

If exists, render that template.
If it does not exist, then does "REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/works/show" exist?

## Leveraging View Paths for the Work Types

I said we wanted to support arbitrary work types.
In fact, I want to provide rudimentary support for work types that may not be defined.

However, I want to allow different view for different work types.

Enter the concept of [rendering with diminishing specificity]({{ site.repo_url }}/blob/2ad3a9a1b56591fa303194988adfade7ec014639/app/presenters/hydramata/works/base_presenter.rb#L79-L96).

This concept introduces a pivot point in the view paths.
It adds the behavior that for each view path, attempt to first render a template for the given work type then for the generic work type.

Given the above view paths, if we were attempting to render an Article's show template via a Works controller.
We would in essence attempt to render in the following order:

1. `"RAILS_ROOT/app/views/hydramata/works/works/article/show"`
1. `REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/hydramata/works/works/article/show`,
1. `RAILS_ROOT/app/views/hydramata/works/works/show`,
1. `REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/hydramata/works/works/show`

The first one we found would be rendered, all of the others would be skipped.

**And yes I know `hydramata/works/works` looks a bit silly. I'm working on that.**

This case is asserted in the [WorkPresenter spec]({{ site.repo_url_file_prefix}}/spec/presenters/hydramata/works/work_presenter_spec.rb).

## But Wait, There's More

And the above rendering strategy applies to PropertySets and Properties.

Assuming we are working with the above Article, and we were rendering the :required property set, we'd attempt to find the template looking in the following locations:

1. `RAILS_ROOT/app/views/hydramata/works/fieldsets/article/my_fieldset/show`,
1. `REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/hydramata/works/fieldsets/article/my_fieldset/show`
1. `RAILS_ROOT/app/views/hydramata/works/fieldsets/my_fieldset/show`,
1. `REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/hydramata/works/fieldsets/my_fieldset/show`
1. `RAILS_ROOT/app/views/hydramata/works/fieldsets/show`,
1. `REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/hydramata/works/fieldsets/show`

And we'd have something similar if we were rendering a :title property:

1. `RAILS_ROOT/app/views/hydramata/works/properties/article/title/show`,
1. `REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/hydramata/works/properties/article/title/show`
1. `RAILS_ROOT/app/views/hydramata/works/properties/title/show`,
1. `REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/hydramata/works/properties/title/show`
1. `RAILS_ROOT/app/views/hydramata/works/properties/show`,
1. `REDACTED/gems/hydramata-works-2ad3a9a1b565/app/views/hydramata/works/properties/show`

These two cases are asserted in the [FieldsetPresenter spec](/spec/presenters/hydramata/works/fieldset_presenter_spec.rb) and the [PropertyPresenter spec](/spec/presenters/hydramata/works/property_presenter_spec.rb).

## Supporting specs

If you want to see this in action, please look at the feature spec that demonstrates the [format and view path overrides]({{ site.repo_url_file_prefix}}/spec/features/format_and_view_path_overrides_spec.rb). This is further supported by the [BasePresenter#render specs]({{ site.repo_url_file_prefix}}/spec/presenters/hydramata/works/base_presenter_spec.rb)

Also a detailed spec for [translations services]({{ site.repo_url_file_prefix}}/spec/features/translation_services_spec.rb) shows the lookup strategy.

## Notes

I'm not yet satisfied with the custom view paths.
In particular I don't know the exact lookup methods I want to use.

I recently discovered the `:variant` option of the view_path pattern matcher.
Most of Rails's view_paths leverage a pattern matching strategy. Below is the pattern for ActionView::OptimizedFileSystemResolver

```ruby
@pattern=":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}",
```

I wonder what :variants might provide?
Because maybe `app/views/works/new.en.html.article.erb` would work or fallback to `app/views/works/new.html.erb`.
Something to explore.