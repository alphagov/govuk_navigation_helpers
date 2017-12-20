## 8.1.1
* Update content in the /end-a-civil-partnership, /get-a-divorce, and /learn-to-drive-a-car tasklists
* Strip non-alphanumeric characters from world location links for related navigation helper.

## 8.1.0
* Update related navigation sidebar helper to return statistical data sets.

## 8.0.0
* Remove special handling of publication formats as the default layouts in government-frontend are sufficient
* Fix a link in tasklist content for /end-a-civil-partnership

## 7.5.1
* Change context for the Get Divorce & End Civil Partnership tasklists

## 7.5.0
* Adds ability to detect if the current page is under test

## 7.4.0

* Adds functionality to render the tasklist content into frontend applications under AB Testing.
* Adds govuk_ab_testing as dependency.
* Introduces TasklistContent & CurrentTasklistAbTest [PR#90](https://github.com/alphagov/govuk_navigation_helpers/pull/90).

## 7.3.0

* Update related navigation sidebar helper to return topical events and worldwide organisations.

## 7.2.0

* Update related navigation sidebar helper to also return world location data

## 7.1.0

* Add helper for rendering related navigation sidebar on content pages with universal layout

## 7.0.0

* Root taxons are now whitelisted, so that only taxons descendant from one of
  the three published root taxons (education, childcare-parenting and world)
  will appear in breadcrumbs and the side bar. See the [PR](https://github.com/alphagov/govuk_navigation_helpers/pull/82) for more information

## 6.3.0

* Allow curated related links to be shown on the new navigation sidebar. If the
  link type `ordered_related_items_overrides` contains links to content items,
  we will use those instead of the "more like this" links from search. These
  links can be added in `content-tagger`.

## 6.2.0

* Remove "Register to vote" section from related links data as deadline of
  May 23rd 2017 has passed.

## 6.1.0

* Add "Register to vote" section to related links data. This will only affect
  completed transactions (apart from register-to-vote) until May 23rd 2017.

## 6.0.2

* Bump gds-api-adapters to 43.0.0

## 6.0.1

* Remove duplicate related links from search for the new taxonomy sidebar.

## 6.0.0

* **BREAKING CHANGE**: Bump gds-api-adapters to 42.2, which makes `lgil`
mandatory when requesting links from Local Links Manager.

## 5.1.0

* Display Elsewhere in GOV.UK and Elsewhere on the web related links on new
  taxonomy sidebar.

## 5.0.0

* **BREAKING CHANGE**: Update the gds-api-adapters gem. This includes a change
  which replaces the `GOVUK-Fact-Check-Id` header with the
  `GOVUK-Auth-Bypass-Id` header when passing on requests from the client to
  APIs. See the [gds-api-adapters changelog](https://github.com/alphagov/gds-api-adapters/blob/master/CHANGELOG.md#4100) for more information on upgrading.
* Limit related links to the first two taxons.

## 4.0.0

* **BREAKING CHANGE**: remove `Guidance::DOCUMENT_TYPES`. Clients should use
  filter guidance content using the `navigation_document_supertype` field which
  has been added to search and the content store.
* Use `navigation_document_supertype` internally in search queries to find
  guidance content.

## 3.2.1

* Add `is_page_parent` flag to the breadcrumb which is the direct parent of the
  current taxon.

## 3.2.0

* Alphabetically sort taxons and related links in the taxonomy sidebar.

## 3.1.1

* Remove `notice` from list of guidance document types.

## 3.1.0

* Allow a statsd client to be passed in via configuration options. This will
  allow us to track how many Rummager searches we run and how long they take.

## 3.0.2

* Sort parent taxons by title before picking the first one for the breadcrumbs.

## 3.0.1

* Return only 3 related items for the taxonomy sidebar.

## 3.0.0

* **BREAKING CHANGE**: remove unnecessary nesting from taxonomy sidebar helper.
  The schema has changed from:

  ```json
  {
    "sections": [
      {
        "title": "String",
        "items": []
      }
    ]
  }
  ```

  to:

  ```json
  {
    "items": []
  }
  ```

* The taxonomy sidebar helper returns an object whose keys are all symbols, as
  required by Govuk Components

## 2.4.1

* Add related content to the taxonomy sidebar helper

## 2.4.0

* Add helper for rendering sidebar on taxonomy content pages.

## 2.3.1

* Convert all ContentItem initialization objects to a hash

## 2.3.0

* Add support for adding the current page to Taxon breadcrumbs

## 2.2.0

* make sure `taxon_breadcrumbs` generates data for both `taxons` and other
  content items tagged to a taxon.

## 2.1.2

* Add SSH agent for Gem publishing

## 2.1.1

* Add `Jenkinsfile` for CI on Jenkins 2

## 2.1.0

* Add helper to render taxon breadcrumbs

## 2.0.0

* Functionality to generate data for the related items component
* Breadcrumbs are now returned in a hash so that they can be passed to
  `govuk_components` directly.

## 1.0.0

* Functionality to generate data for the breadcrumb component
