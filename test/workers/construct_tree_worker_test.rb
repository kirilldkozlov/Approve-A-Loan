require 'test_helper'
require 'sidekiq/testing'

class ConstructTreeWorkerTest < ActiveSupport::TestCase
  setup do
    Sidekiq::Testing.fake!
  end

  test "ConstructTreeWorker is queued properly" do
    assert_equal 0, ConstructTreeWorker.jobs.size
    ConstructTreeWorker.perform_async
    assert_equal 1, ConstructTreeWorker.jobs.size
  end
end
