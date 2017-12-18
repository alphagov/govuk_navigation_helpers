require 'spec_helper'

module GovukNavigationHelpers
  RSpec.describe CurrentTasklistAbTest do
    let(:tasklist) { TasklistContent.current_tasklist('/vehicles-can-drive') }

    it "indicates when to show the task list components" do
      request = double('request', headers: {
        'HTTP_GOVUK_ABTEST_TASKLISTSIDEBAR' => 'B',
        'HTTP_GOVUK_ABTEST_TASKLISTHEADER' => 'B'
        })
      ab_test = described_class.new(current_tasklist: tasklist, request: request)
      expect(ab_test.show_tasklist_sidebar?).to be true
      expect(ab_test.show_tasklist_header?).to be true
    end

    it "indicates when to not show the task list components" do
      request = double('request', headers: {
        'HTTP_GOVUK_ABTEST_TASKLISTSIDEBAR' => 'A',
        'HTTP_GOVUK_ABTEST_TASKLISTHEADER' => 'A'
        })
      ab_test = described_class.new(current_tasklist: tasklist, request: request)
      expect(ab_test.show_tasklist_sidebar?).to be false
      expect(ab_test.show_tasklist_header?).to be false
    end

    it "copes with a mixture when to not show the task list components" do
      request = double('request', headers: {
        'HTTP_GOVUK_ABTEST_TASKLISTSIDEBAR' => 'B',
        'HTTP_GOVUK_ABTEST_TASKLISTHEADER' => 'A'
        })
      ab_test = described_class.new(current_tasklist: tasklist, request: request)
      expect(ab_test.show_tasklist_sidebar?).to be true
      expect(ab_test.show_tasklist_header?).to be false
    end

    it "configures the response vary header correctly " do
      request = double('request', headers: {
        'HTTP_GOVUK_ABTEST_TASKLISTSIDEBAR' => 'A',
        'HTTP_GOVUK_ABTEST_TASKLISTHEADER' => 'B'
        })
      response = double('response', headers: {})
      ab_test = described_class.new(current_tasklist: tasklist, request: request)

      ab_test.set_response_header(response)

      expect(response.headers["Vary"]).to eq("GOVUK-ABTest-TaskListSidebar, GOVUK-ABTest-TaskListHeader")
    end

    it "configures the response vary header correctly when the page is not under test" do
      request = double('request', headers: {
        'HTTP_GOVUK_ABTEST_TASKLISTSIDEBAR' => 'A',
        'HTTP_GOVUK_ABTEST_TASKLISTHEADER' => 'B'
        })
      response = double('response', headers: {})
      tasklist = TasklistContent.current_tasklist("/not_under_test")
      ab_test = described_class.new(current_tasklist: tasklist, request: request)

      ab_test.set_response_header(response)

      expect(response.headers["Vary"]).to be nil
    end
  end
end
