Rails.application.routes.draw do
  mount GovukNavigationHelpers::Engine => "/govuk_navigation_helpers"
end
