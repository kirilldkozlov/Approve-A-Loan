class ConstructTreeWorker
  include Sidekiq::Worker

  def perform
    Analyzer.new.sync
  end
end
