# GOV.UK Navigation Helpers

This is a gem to share code between GOV.UK frontends.

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

### Usage

Get the JSON representation of a page using the [gds-api-adapters](https://github.com/alphagov/gds-api-adapters/):

```ruby
content_store = GdsApi::ContentStore.new(Plek.current.find("content-store"))
content_item = content_store.content_item("/register-to-vote")
```

Initialise the helper:

```ruby
@nav = GovukNavigationHelpers::NavigationHelper.new(content_item)
```

Render the component:

```ruby
<%= render partial: 'govuk_component/breadcrumbs', locals: { breadcrumbs: @nav.breadcrumbs }
```

### Running the test suite

`bundle exec rake`

### Documentation

See [RubyDoc](http://www.rubydoc.info/gems/govuk_navigation_helpers) for some limited documentation.

To run a Yard server locally to preview documentation, run:

    $ bundle exec yard server --reload

## Licence

    [MIT License](LICENCE.txt)
