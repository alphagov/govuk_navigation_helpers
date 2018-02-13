# GOV.UK Navigation Helpers

This is a gem to share code between GOV.UK frontends.

** It should not be used anymore ***

This gem was a temporary solution to the problem of sharing code used to generate
the input to components. Since the components can now be built into the [govuk_publishing_components gem](https://github.com/alphagov/govuk_publishing_components), it is no longer necessary.

## Nomenclature

- **content item**: An object returned by the content store

## Technical documentation

These helpers format data from the [content store](https://github.com/alphagov/content-store) for use with [GOV.UK Components](http://govuk-component-guide.herokuapp.com/about).

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'govuk_navigation_helpers', '~> VERSION'
```

And then execute:

    $ bundle

### Configuration

This gem allows the configuration of:

- an error handler class (e.g. `Airbrake`), that implements a `notify` method
  which takes an exception object (by default, it prints the exception to stdout
  when not configured);
- a statsd client - when not configured, it does not do anything. This client
  should implement `increment(metric)` and `time(metric, &block)`.

### Usage

Get the JSON representation of a page and initialise the helper:

```ruby
def some_controller_method
  content_item = Services.content_store.content_item("/register-to-vote")
  @navigation = GovukNavigationHelpers::NavigationHelper.new(content_item)
end
```

Render the component:

```ruby
<%= render partial: 'govuk_component/breadcrumbs', locals: @navigation.breadcrumbs %>
```

```ruby
<%= render partial: 'govuk_component/related_items', locals: @navigation.related_items %>
```

### Running the test suite

`bundle exec rake`

### Documentation

See [RubyDoc](http://www.rubydoc.info/gems/govuk_navigation_helpers) for some limited documentation.

To run a Yard server locally to preview documentation, run:

    $ bundle exec yard server --reload

## Licence

[MIT License](LICENCE.txt)
