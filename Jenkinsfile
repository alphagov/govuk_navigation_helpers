#!/usr/bin/env groovy

REPOSITORY = 'govuk_navigation_helpers'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage('Checkout') {
      checkout scm
    }

    stage('Clean') {
      govuk.cleanupGit()
      govuk.mergeMasterBranch()
    }

    stage("Set up content schema dependency") {
      govuk.contentSchemaDependency()
    }

    stage('Bundle') {
      echo 'Bundling'
      govuk.bundleGem()
    }

    stage('Linter') {
      govuk.rubyLinter()
    }

    govuk.setEnvar('RAILS_ENV', 'test')
    testGem()
    // govuk.runTests('spec')

    if(env.BRANCH_NAME == "master") {
      stage('Publish Gem') {
        govuk.publishGem(REPOSITORY, env.BRANCH_NAME)
      }
    }

  } catch (e) {
    currentBuild.result = 'FAILED'
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    throw e
  }
}

def testGem(extraVersions = []) {
  def supportedRubyVersions = ['2.3']
  supportedRubyVersions.addAll(extraVersions)
  testGemWithAllRubies(supportedRubyVersions)
}

/**
 * Runs the tests with all the Ruby versions that are currently supported.
 *
 * Adds a Jenkins stage for each Ruby version, so do not call this from within
 * a stage.
 */
def testGemWithAllRubies(supportedRubyVersions) {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  for (rubyVersion in supportedRubyVersions) {
    stage("Test with ruby $rubyVersion") {
      echo "Removing Gemfile.lock"
      sh "rm -f Gemfile.lock"
      echo "Setting Ruby version"
      govuk.setEnvar("RBENV_VERSION", rubyVersion)
      echo "Bundling gem"
      govuk.bundleGem()

      echo "Running tests"
      govuk.runTests('spec')
    }
  }
  sh "unset RBENV_VERSION"
}
