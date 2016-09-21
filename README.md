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

Get the JSON representation of a page and initialise the helper:

```ruby
def some_controller_method
  content_item = Services.content_store.content_item("/register-to-vote")
  @navigation = GovukNavigationHelpers::NavigationHelper.new(content_item)
end
```

Render the component:

```ruby
<%= render partial: 'govuk_component/breadcrumbs', locals: { breadcrumbs: @navigation.breadcrumbs }
```

### Running the test suite

`bundle exec rake`

### Documentation

See [RubyDoc](http://www.rubydoc.info/gems/govuk_navigation_helpers) for some limited documentation.

To run a Yard server locally to preview documentation, run:

    $ bundle exec yard server --reload

## Licence

    [MIT License](LICENCE.txt)
